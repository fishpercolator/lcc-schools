FROM ruby:2.3
MAINTAINER Rich Daley <rich@fishpercolator.co.uk>
ENV REFRESHED_AT 2017-03-10

# These lines are needed for JavaScript testing with poltergeist
RUN apt-get update -y && apt-get install less build-essential chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev -y && apt-get clean
ADD https://fishpercolator.co.uk/files/phantomjs-2.1.1-linux-x86_64.tar.bz2 /usr/local/share/
RUN tar -C /usr/local/share -xjf /usr/local/share/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs

RUN adduser --uid 1001 --disabled-password --gecos "" rails

RUN gem install bundler

ENV APP_HOME /usr/src/lcc-schools
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile BUNDLE_JOBS=2 BUNDLE_PATH=/bundle

RUN bundle install

ENV RAILS_ENV       production
ENV DOMAIN_NAME     localhost
# NOTE: ALWAYS override this or your sessions will be insecure!
ENV SECRET_KEY_BASE 06f8d71b717a0f44dc99a75442745ee89bf6858263787511d31ee3cb59f2f7bf036120b05355f2456380e5b3d647a56a0d1d7ef4c04505f614f3665057a11dca

ADD . $APP_HOME

#RUN RAILS_ENV=production bundle exec rake assets:precompile

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
