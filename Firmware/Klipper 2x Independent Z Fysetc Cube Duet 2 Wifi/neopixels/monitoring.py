#!/usr/bin/env python
import board
import time
import requests
import json
import board
import neopixel
import multiprocessing


class StatusMonitor:

    def __init__(self):
        self.status = None
        self.bed_temp = 0
        self.bed_given = 0
        self.extruder_temp = 0
        self.extruder_given = 0
        self.progress = 0
        self.pixel_pin = board.D18
        self.num_pixels = 48
        self.color = None
        self.status_to_color_dict = {
            'Operational': (255, 255, 255),
            'Printing': (0, 255, 0),
            'Pausing': (0, 191, 255),
            'Paused': (0, 0, 255),
            'Cancelling': (220, 20, 60),
            'Error': (255, 0, 0),
            'Offline': (255, 0, 0),
            'Offline after error': (139, 0, 0),
            'Opening serial connection': (248, 248, 255),
            None: None
        }
        self.pixels = neopixel.NeoPixel(
            self.pixel_pin, self.num_pixels, brightness=0.2, auto_write=False,
            pixel_order=neopixel.GRB
        )

        for i in range(0, 47):
            self.pixels[i] = (0, 0, 0)
        self.pixels.show()

        self.t = multiprocessing.Process(target=waiting, args=(0.03, self.pixels))
        self.t.start()

    def check_status(self):
        try:
            printer = requests.get("http://localhost:7125/api/printer")
            printer_dict = printer.json()
            extruder_temp = str(printer_dict['temperature']['tool0']['actual'])
            extruder_given = str(printer_dict['temperature']['tool0']['target'])
            self.extruder_temp = calulate_pos(240, extruder_temp, 20)
            self.extruder_given = calulate_pos(240, extruder_given, 20)
            bed_temp = str(printer_dict['temperature']['bed']['actual'])
            bed_given = str(printer_dict['temperature']['bed']['target'])
            self.bed_temp = calulate_pos(80, bed_temp, 23)
            self.bed_given = calulate_pos(80, bed_given, 23)


        except:
            print("Jeszcze service nie bangla")

        try:
            job = requests.get("http://localhost:7125/api/job")
            job_progerss = requests.get("http://localhost:7125/printer/objects/query?virtual_sdcard=progress")
            job_dict = job.json()
            job_progerss_dict = job_progerss.json()
            self.status = str(job_dict['state'])
            progress = str(job_progerss_dict['result']['status']['virtual_sdcard']['progress'])
            if progress == "0.0":
                self.progress = 16
            else:
                self.progress = calulate_pos(100, progress, 0)

        except:
            print("Jeszcze service nie bangla")
            print(self.extruder_temp, self.bed_temp, self.progress, self.status)

    def update_pixels(self):

        if self.extruder_temp != 0:

            if self.t.is_alive():
                self.t.terminate()

            progress_color = self.status_to_color_dict[self.status]
            for i in range(16):
                if self.bed_temp <= self.bed_given:
                    if i <= self.bed_temp:
                        self.pixels[(15 - i) % 16] = (0, 0, 255)
                    elif i <= self.bed_given:
                        self.pixels[(15 - i) % 16] = (0, 0, 100)
                    else:
                        self.pixels[(15 - i) % 16] = (0, 0, 0)
                else:
                    if i <= self.bed_given:
                        self.pixels[(15 - i) % 16] = (0, 0, 255)
                    elif i <= self.bed_temp:
                        self.pixels[(15 - i) % 16] = (0, 100, 255)
                    else:
                        self.pixels[(15 - i) % 16] = (0, 0, 0)

                if self.extruder_temp <= self.extruder_given:
                    if i <= self.extruder_temp:
                        self.pixels[((15 - i + 13) % 16) + 16] = (255, 0, 0)
                    elif i <= self.extruder_given:
                        self.pixels[((15 - i + 13) % 16) + 16] = (100, 0, 0)
                    else:
                        self.pixels[((15 - i + 13) % 16) + 16] = (0, 0, 0)
                else:
                    if i <= self.extruder_given:
                        self.pixels[((15 - i + 13) % 16) + 16] = (255, 0, 0)
                    elif i <= self.extruder_temp:
                        self.pixels[((15 - i + 13) % 16) + 16] = (255, 100, 0)
                    else:
                        self.pixels[((15 - i + 13) % 16) + 16] = (0, 0, 0)

                if i <= self.progress:
                    self.pixels[((15 - i + 1) % 16) + 32] = progress_color
                else:
                    self.pixels[((15 - i + 1) % 16) + 32] = (0, 0, 0)
            #print (self.pixels)
            self.pixels.show()


def calulate_pos(max, value, offset):

    pos = (float(value) - offset) / (max - offset) * 16
    if pos < 0:
        pos = 0
    return pos


def waiting(interval, pixels):

    colorlist = [(255, 0 ,0), (0, 255, 0), (0, 0, 255)]

    for i in range(3):
        print ("Petelka " + str(i))
        for j in range(16):
            pixel = ((15 - j) % 16)
            pixels[pixel] = colorlist[i]
            pixels[pixel + 16] = colorlist[i]
            pixels[pixel + 32] = colorlist[i]
            pixels[pixel + 1] = (0, 0, 0)
            pixels[pixel + 17] = (0, 0, 0)
            if j == 0:
                pixels[0] = (0, 0, 0)
            else:
                pixels[pixel + 33] = (0, 0, 0)
            pixels.show()
            time.sleep(interval)
    colorbase = [(1, 0, 0), (0, 1, 0), (0, 0, 1)]
    color = (0, 0, 0)
    while True:
        for i in range(3):
            for j in range(511):
                if j <= 255:
                    color = tuple(col * j for col in colorbase[i])
                else:
                    color = tuple((col * (511 - j)) for col in colorbase[i])
                for k in range(48):
                    pixels[k] = color
                pixels.show()    
                time.sleep(interval/100)
    """while True:
        for j in range(96):
            if j <= 47:
                pixels[47 - j] = (255, 255, 255)
            else:
                pixels[95 - j] = (0, 0, 0)
            pixels.show()
            time.sleep(interval)
    """

Monitor = StatusMonitor()
while True:
    Monitor.check_status()
    Monitor.update_pixels()
    time.sleep(0.2)
