FROM postgres:9.5


# Don't use this in production. It's my first "real" docker image.
# Not to mention Libpostal's stable but "new" and might change (i.e.
# add a more deliberate versioning scheme of the code + the data)
# and pgsql-postal is also subject to change. So yeah...
# Consider this "radically experimental".
MAINTAINER David Riordan <dr@daveriordan.com>

# LIBPOSTAL
RUN apt-get update

# Install Libpostal dependencies
RUN apt-get install -y \
	git \
	make \
	curl \
	libsnappy-dev \
	autoconf \
	automake \
	libtool \
	pkg-config
# Download libpostal source to /usr/local/libpostal
RUN cd /usr/local && \
	git clone https://github.com/openvenues/libpostal

# Create Libpostal data directory at /var/libpostal/data
RUN cd /var && \
	mkdir libpostal && \
	cd libpostal && \
	mkdir data

# Install Libpostal from source
RUN cd /usr/local/libpostal && \
	./bootstrap.sh && \
	./configure --datadir=/var/libpostal/data && \
	make
	make install

## PGSQL-POSTAL -- Bindings
# Download bindings - pgsql-postal - from source to /usr/lib/pgsql-postal
RUN cd /usr/lib && \
	git clone https://github.com/pramsey/pgsql-postal.git

RUN cd /usr/lib/pgsql-postal && \
	make
	make install

## Cleanup should happen here, but it won't for now.
