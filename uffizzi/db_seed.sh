#!/usr/bin/env bash

<<<<<<< HEAD
bundle exec rake db:seed

tail -f /dev/null
=======
SEEDS_MULTIPLIER=2 bundle exec rake db:seed:staging

tail -f /dev/null
>>>>>>> upstream/main
