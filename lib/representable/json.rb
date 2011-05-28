require 'json'
require 'representable/bindings/json_bindings'

module Representable
  module JSON
    BINDING_FOR_TYPE = {  # TODO: refactor #representable_accessor for better extendability.
      :text     => TextBinding,
    }
    def self.binding_for_definition(definition)
      (BINDING_FOR_TYPE[definition.sought_type] or ObjectBinding).new(definition)
    end
    
    def self.included(base)
      base.class_eval do
        attr_accessor :data_record
        include Representable
        include InstanceMethods
      end
      base.extend ClassMethods  # DISCUSS: do that dynamically?
    end
    
    module ClassMethods
      # Creates a new Ruby object from XML using mapping information declared in the class.
      #
      # Example:
      #  book = Book.from_xml("<book><name>Beyond Java</name></book>")
      def from_json(data, options={})
        # DISCUSS: extract #from_json call in Bindings to this place.
        data = ::JSON[data] if data.is_a?(String) # DISCUSS: #from_json sometimes receives a string (in nestings).
        data ||= {}
        
        data = data[representation_name] unless options[:wrap] == false
        
        create_from_json.tap do |inst|
          refs = representable_attrs.map {|attr| JSON.binding_for_definition(attr) }
          
          refs.each do |ref|
            value = ref.value_in(data)
            
            inst.send(ref.definition.setter, value)
          end
        end
      end
      
    private
      def create_from_json(*args)
        new(*args)
      end
    end
    
    module InstanceMethods # :nodoc:
      # writing some crazy code here!
      def initialize(data_record)
        @data_record = data_record
      end

      # Returns a Nokogiri::XML object representing this object.
      def to_json(options={})
        attributes = {}.tap do |root|
          refs = self.class.representable_attrs.map {|attr| JSON.binding_for_definition(attr) }
          refs.each do |ref|
            value = find_by_type(ref) # DISCUSS: eventually move back to Ref.
            ref.update_json(root, value) if value
          end
        end
        
        options[:wrap] == false ? attributes : {self.class.representation_name => attributes}
      end

      def find_by_type(ref)
        value = public_send(ref.accessor)
        if ref.respond_to?(:sought_type)
          ref.sought_type.new(value)
        else
          value
        end
      end
    end
  end # Xml
end
