#!/bin/sh -e

if [ -z $PREFIX ]; then
    PREFIX=/usr/local/cluster-admin
fi

case `uname` in
    FreeBSD)
	os='FreeBSD'

	;;
    Linux)
	#
	if [ -e /etc/redhat-release ]; then
	    os='CentOS'
	else
	    printf "Only RHEL-based Linux is supported.\n"
	    exit 1
	fi

	DATADIR=$PREFIX/share/cluster-admin
	mkdir -p $DATADIR
	cp CentOS/WWW/* $DATADIR
	;;
    *)
	printf "Unsupported OS: `uname`\n"
	exit 1
esac

set -x
for dir in bin sbin libexec; do
    mkdir -p ${DESTDIR}${PREFIX}/$dir
done
rm -f ${DESTDIR}${PREFIX}/sbin/cluster-*
rm -f ${DESTDIR}${PREFIX}/bin/cluster-*
cp $os/Sys-scripts/* ${DESTDIR}${PREFIX}/sbin
cp $os/User-scripts/* ${DESTDIR}${PREFIX}/bin || true
cp Common/Sys-scripts/* ${DESTDIR}${PREFIX}/sbin
cp Common/User-scripts/* ${DESTDIR}${PREFIX}/bin
chmod 750 ${DESTDIR}${PREFIX}/sbin/*
chmod 755 ${DESTDIR}${PREFIX}/bin/*

cp Common/*.awk ${DESTDIR}${PREFIX}/libexec

# FIXME: Create and install man pages

mkdir -p ${DESTDIR}${DATADIR}/WWW
cp Common/Share/* ${DESTDIR}${DATADIR}
if [ -e $os/Share ]; then
    cp $os/Share/* ${DESTDIR}${DATADIR}
fi
cp $os/WWW/* ${DESTDIR}${DATADIR}/WWW

sed -e "s|add-gecos.awk|${PREFIX}/libexec/add-gecos.awk|g" \
    Common/Sys-scripts/slurm-usage-report \
    > ${DESTDIR}${PREFIX}/sbin/slurm-usage-report

sed -e "s|cluster-admin.conf|${PREFIX}/etc/cluster-admin.conf|g" \
    Common/Sys-scripts/cluster-lowest-uid \
    > ${DESTDIR}${PREFIX}/sbin/cluster-lowest-uid

src_prefix=$(dirname $(dirname) $(pwd))
for script in `fgrep -l '%%PREFIX%%' */Sys-scripts/*`; do
    sed -e "s|%%PREFIX%%|${PREFIX}|g" "s|%%SRC_PREFIX|$src_prefix|g" $script \
    > ${DESTDIR}${PREFIX}/sbin/`basename $script`
done

for script in `fgrep -l '%%PREFIX%%' */User-scripts/*`; do
    sed -e "s|%%PREFIX%%|${PREFIX}|g" "s|%%SRC_PREFIX|$src_prefix|g" $script \
    > ${DESTDIR}${PREFIX}/bin/`basename $script`
done

