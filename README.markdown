# irc-logger
[irc-logger][irc-logger] is IRC (Internet Reley Chat) logging and searching engine! It is complete merb application which you can use on your own domain.

## How to install

### Dependencies

#### System depenendencies
* [Ruby Interpreter][ruby] >= 1.8.6
* [Memcached System][memcached] >= 1.2
* [Sphinx Search Engine][sphinx] >= 0.9.8
* [PostgreSQL][postgresql] >= 8.2

#### Ruby Gems
* [merb][merb] >= 1.0.4
* [datamapper][datamapper] >= 0.9.8
* do_postgres >= 0.9.8
* [starling][starling] >= 0.9.8
* [dm-sphinx-adapter][dm-sphinx-adapter] >= 0.6 
* [net-yail][net-yail] >= 1.2
* memcached >= 1.0

### Installation
1. Make sure that you have installed dependencies
2. Create database (currently supported only PostgreSQL - you can try with others on you own risk)
3. Get the sources `git clone git://github.com/alfanick/irc-logger.git` or [download][irc-logger] the stable version
4. Create directories `mkdir tmp var var/sphinx`
5. Configure irc-logger
   * Copy `config/database.example.yml` to `config/database.yml`
     * Set there hostname, username, password, database name
   * Copy `config/sphinx.example.conf` to `config/sphinx.conf`
     * Set there hostname, username, password, database name
   * Set memcache servers in `config/cache.yml`
     * If you want you can change caching times (in seconds)
   * Configure bot listeners
     * Set starling server
     * Add listeners names
   * Add database indexing to cron `rake sphinx:delta sphinx:merge`
6. Initialize database `rake db:automigrate`.
7. Initialize sphinx index `rake sphinx:main`
8. Add some channels using `rake irc:join url=server.host/#channel`
9. Configure web server (irc-logger is Rack application)

### Running
1. Run memcache server
2. Run starling server
3. Run irc listeners `rake irc:listener name=my_listener_0` (to stop them see next point)
4. Run irc logging `rake irc:listen` - to disable kill this process (`^C`) and run `rake irc:stop` to disable listeners
5. Run sphinx searching deamon `rake sphinx:listen` - to stop run `rake sphinx:stop`
6. That's all - make sure that web server is working!

## License
> irc-logger - IRC logging and searching engine
> Copyright (C) 2008 Amadeusz Jasak
>
> This program is free software; you can redistribute it and/or modify
> it under the terms of the GNU General Public License as published by
> the Free Software Foundation; either version 2 of the License.
>
> This program is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU General Public License for more details.
> 
> You should have received a copy of the GNU General Public License along
> with this program; if not, write to the Free Software Foundation, Inc.,
> 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

## Author
If you have questions write to [Amadeusz Jasak][email] (the author). Please [donate][donate]!

  [irc-logger]: http://github.com/alfanick/irc-logger
  
  [ruby]: http://ruby-lang.org
  [memcached]: http://www.danga.com/memcached/
  [sphinx]: http://www.sphinxsearch.com
  [postgresql]: http://www.postgresql.org
  
  [merb]: http://merbivore.com
  [datamapper]: http://datamapper.org
  [starling]: http://github.com/defunkt/starling
  [dm-sphinx-adapter]: http://github.com/shanna/dm-sphinx-adapter
  [net-yail]: http://rubyforge.org/projects/ruby-irc-yail
  
  [email]:  mailto:amadeusz.jasak@gmail.com
  [donate]: http://pledgie.org/campaigns/2048