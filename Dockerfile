FROM ubuntu:16.04

COPY ./chatll.conf /root/.chatll/chatll.conf

COPY . /chatll
WORKDIR /chatll

#shared libraries and dependencies
RUN apt update
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
RUN apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev

#BerkleyDB for wallet support
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev

#upnp
RUN apt-get install -y libminiupnpc-dev

#ZMQ
RUN apt-get install -y libzmq3-dev

#build chatll source
RUN ./autogen.sh
RUN ./configure
RUN make clean
RUN make
RUN make install

#open service port
EXPOSE 9776 19776

CMD ["chatlld", "--printtoconsole"]