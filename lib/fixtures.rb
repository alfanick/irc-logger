module Fixtures
  class Manager
    class << self
      def init
        @@fixtures = {}
      end
      
      def load
        Merb.logger.debug("Loading fixtures ...")
        unless Merb.env?("production")
          directory = Merb.root / "app" / "fixtures"
          if File.exist?(directory)
            Dir[directory / "*.rb"].each do |file|
              Kernel.load(file)
            end
          else
            raise 'FixturesDirectoryNotFound'
          end
        end
      end

      def create(klass, name, &block)
        unless object = klass.fixture(name)
          object = klass.new
          @@fixtures[klass] << {:name => name, :object => object}
        end
        object.instance_eval(&block) if block_given?
        object.save! if object.dirty?
        object
      end
      
      def fixture(klass, name)
        if fix = (@@fixtures[klass] ||= []).find {|e| e[:name] == name}
          fix[:object]
        end
      end
      
      def fixtures(klass)
        @@fixtures[klass]
      end
      
      def delete_fixtures(klass)
        @@fixtures[klass] = []
      end
      
      def save_all
        @@fixtures.each_pair do |_, fixtures|
          fixtures.each {|f| f[:object].save}
        end
      end
    end
  
  end

  module Extensions
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def fixture(name)
        Manager.fixture(self, name)
      end
      
      def fixtures
        Manager.fixtures(self)
      end

      def delete_fixtures
        Manager.delete_fixtures(self)
      end
    end
  end
end

models = []
ObjectSpace.each_object(Class)  do |klass|
  if klass.included_modules.include?(DataMapper::Resource)
    klass.send(:include, Fixtures::Extensions)
  end
end

module Kernel
  def fixture_for(klass, name, &block)
    Fixtures::Manager.create(klass, name, &block)
  end
end

#DataMapper.auto_migrate!
Fixtures::Manager.init
