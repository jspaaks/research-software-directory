#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

rm /app/celerybeat.pid

#celery -A seedorf.taskapp beat -l INFO
celery -A src.task_schedule beat -l INFO
