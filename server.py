#!/usr/bin/env python3
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from pathlib import Path
import logging,os,signal
HOST=os.getenv("REFLEX_HOST","0.0.0.0");PORT=int(os.getenv("REFLEX_PORT","80"));ROOT=Path(os.getenv("REFLEX_ROOT",Path(__file__).parent/"public")).resolve()
class Handler(SimpleHTTPRequestHandler):
 def __init__(self,*a,**kw):super().__init__(*a,directory=str(ROOT),**kw)
 def end_headers(self):
  self.send_header("X-Content-Type-Options","nosniff");self.send_header("X-Frame-Options","DENY");self.send_header("Referrer-Policy","no-referrer");self.send_header("Cache-Control","no-cache");super().end_headers()
 def log_message(self,f,*a):logging.info("http %s - %s",self.address_string(),f%a)
 def log_error(self,f,*a):logging.error("http %s - %s",self.address_string(),f%a)
logging.basicConfig(level=logging.INFO,format="%(asctime)s %(levelname)s %(message)s")
server=ThreadingHTTPServer((HOST,PORT),Handler)
def stop(n,_):logging.info("Signal %s received; shutting down",n);raise KeyboardInterrupt
signal.signal(signal.SIGTERM,stop);logging.info("Starting Reflex: root=%s address=%s port=%s",ROOT,HOST,PORT)
try:server.serve_forever()
except KeyboardInterrupt:pass
finally:server.server_close();logging.info("Reflex service stopped")
