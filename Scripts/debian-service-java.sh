#!/bin/bash
### BEGIN INIT INFO
# Provides:          _SIMPLE_SERVICE_
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Linux Service
### END INIT INFO

SERVICE_NAME=_SIMPLE_SERVICE_
PATH_SERVICE=/opt/_SERVICE_
JAR_NAME=$PATH_SERVICE/example_jar.jar
PID_PATH_NAME=/opt/_SERVICE_/_SERVICE_-pid
case $1 in
    start)
        echo "Starting $SERVICE_NAME ..."
        if [ ! -f $PID_PATH_NAME ]; then
            nohup java -cp $JAR_NAME >> $PATH_SERVICE/$SERVICE_NAME.out 2>&1&
                        echo $! > $PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is already running ..."
        fi
    ;;
    stop)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            echo "$SERVICE_NAME stoping ..."
            kill $PID;
            echo "$SERVICE_NAME stopped ..."
            rm $PID_PATH_NAME
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
    restart)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            echo "$SERVICE_NAME stopping ...";
            kill $PID;
            echo "$SERVICE_NAME stopped ...";
            rm $PID_PATH_NAME
            echo "$SERVICE_NAME starting ..."
            nohup java -cp $JAR_NAME >> $PATH_SERVICE/$SERVICE_NAME.out 2>&1&
                        echo $! > $PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
esac
