module IuMoip
  class XML
    class Base
      include IuMoip::XML::CreateNode
      attr_reader :parent, :doc
      def initialize(_doc, _parent)
        @parent = _parent
        @doc  = _doc
      end

      def self.name(n = nil)
        return @name unless @name.nil?
        @name = n || self.to_s.split('::').last
      end

      def self.name=(n)
        @name = n
      end

      def base_element
        @base_element ||= create_node(parent, self.class.name)
      end

      def self.implement_set_nodes(*args)
        args.each do |method|
          define_method("#{method}=") do |val|
            v = instance_variable_get("@#{method}")
            unless v
              v = create_node(base_element, snake_case_to_camel_case(method))
            end
            instance_variable_set("@#{method}", val)
            v.content = val
          end
          define_method(method) do 
            instance_variable_get("@#{method}")
          end
        end
      end
    end
  end
end