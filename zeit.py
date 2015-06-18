#!/usr/bin/python

# monitor zeitgeist and do stuff
from zeitgeist.client import ZeitgeistClient
from zeitgeist.datamodel import TimeRange, Event
from gobject import MainLoop

#import hamster.client
class e_handler:
   def handler(self, tr, ev):
      # because the mainloop appears to catch exceptions
      from traceback import print_exc
      from urlparse import urlparse
      try:
         # FIXME insert clever rules here
         app = urlparse(ev[0].actor).netloc
         #desk = open("/usr/share/applications/" + app)
         #comments = filter(lambda x: x.startswith("Comment[en_GB]="), desk)
         #comment = comments[0].split("=")[1].strip()
         #self.add_fact(comment + " - " + ev[0].subjects[0].text)
         print(ev[0].subjects[0].text)
      except:
         print_exc()

hh = e_handler()
ml = MainLoop()
ZeitgeistClient().install_monitor(
    TimeRange.from_now(),
    [Event()],
    hh.handler,
    hh.handler)
ml.run()
