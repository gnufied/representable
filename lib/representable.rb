require 'active_support'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inflections.rb'
require 'active_support/core_ext/hash/reverse_merge.rb'

require 'hooks/inheritable_attribute'


require 'representable/definition'
require 'representable/nokogiri_extensions'

#require 'representable/xml' # TODO: do that dynamically.

module Representable
  def self.included(base)
    base.class_eval do
      extend  ClassMethods::Accessors, ClassMethods::Declarations
      
      extend Hooks::InheritableAttribute
      inheritable_attr :representable_attrs
      self.representable_attrs = []
      
      inheritable_attr :explicit_representation_name  # FIXME: move to Accessors.
    end
  end
  
  module ClassMethods # :nodoc:
    module Declarations
      def definition_class
        Definition
      end
      
      def representable_property(*args) # TODO: make it accept 1-n props.
        attr = representable_attr(*args)
        delegate attr.accessor, :to => :data_record
        delegate "#{attr.accessor}=", :to => :data_record
      end
      
      def representable_collection(name, options={})
        options[:as] = [options[:as]].compact
        representable_property(name, options)
      end
      
    private
      def representable_attr(name, options={})
        definition_class.new(name, options).tap do |attr|
          representable_attrs << attr
        end
      end
      
      def representable_reader(*syms, &block)
        representable_attr(*syms, &block).each do |attr|
          add_reader(attr)
        end
      end
      
      def add_reader(attr)
        define_method(attr.accessor) do
          instance_variable_get(attr.instance_variable_name)
        end
      end
    end

    module Accessors
      def representation_name=(name)
        self.explicit_representation_name = name
      end
      
      def representation_name
        explicit_representation_name or name.split('::').last.underscore
      end
    end
  end
end
