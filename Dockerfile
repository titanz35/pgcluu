FROM fedora:latest
COPY . /usr/src/pgcluu
WORKDIR /usr/src/pgcluu
ENV  PGCLUU_STATS_DIR=/tmp/pgcluu_stats
ENV PGCLUU_REPORT_DIR=/tmp/pgcluu_report
ENV              PATH=/usr/src/pgcluu:$PATH
ENV POSTGRES_USERNAME=postgres
ENV POSTGRES_PASSWORD=postgres
ENV       POSTGRES_DB=postgres
ENV POSTGRES_HOSTNAME=postgres
RUN dnf install -y \
    perl \
    perl-Getopt-Long.noarch \
    perl-Storable \
    postgresql \
    && dnf clean all \
    && perl ./Makefile.PL \
    && make \
    && make install \
    && mkdir -p $PGCLUU_STATS_DIR $PGCLUU_REPORT_DIR
ENTRYPOINT echo -e "\t Hit CTRL-\ (SIGQUIT) to stop the collection and generate the report" ; \
           pgcluu_collectd -i 60 $PGCLUU_STATS_DIR -h $POSTGRES_HOSTNAME -U $POSTGRES_USERNAME -d $POSTGRES_DB ; \
           pgcluu -o $PGCLUU_REPORT_DIR $PGCLUU_STATS_DIR
