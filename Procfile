web: ./bin/puma -t ${PUMA_MIN_THREADS:-8}:${PUMA_MAX_THREADS:-12} -w ${PUMA_WORKERS:-2} -p $PORT -e ${RACK_ENV:-development}
worker: ./bin/sidekiq RAILS_ENV=${RACK_ENV:-development}
