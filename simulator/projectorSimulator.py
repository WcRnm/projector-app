import socket

import constants as c


class ProjectorSim:
    def __init__(self, model):
        self.model = model
        self.port = c.PORT
        self.host = '127.0.0.1'
        self.socket = None

    def run(self):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.bind((self.host, self.port))
            s.listen()

            print("Listening on port ", self.port)

            while True:
                pending = bytearray()
                conn, addr = s.accept()
                try:
                    with conn:
                        print('Connected by ', addr)
                        while True:
                            data = conn.recv(64)
                            if not data:
                                break

                            # append data to pending messages
                            for b in data:
                                pending.append(data[b])

                            while self.handle_message(pending):
                                continue
                finally:
                    conn.close()

      #def read_packet(self, data):
      #   if len(data) < 3:
      #      return None

      #   _loc1_ = data.pop(0)
      #   _loc2_ = data.pop(1)
      #   _loc3_ = _loc1_ * 256 + _loc2_
      #   if(m_buffer.length < _loc3_ + 3):
      #      return None
      #   var _loc4_:Array = m_buffer.splice(0,_loc3_ + 3)
      #   return _loc4_

    def handle_message(self, data):
        print('   Got $ bytes'.format(len(data)))

        while len(data) > 0:
            data.pop(0)

        return False


def main(model=c.INFOCUS_IN2128HDx):
    sim = ProjectorSim(model)

    sim.run()


if __name__ == "__main__":
    main()
