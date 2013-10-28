module IuMoip
  class XML
    class Base
      include IuMoip::XML::CreateNode
      attr_reader :root
      def initialize(_root)
        @root = _root
      end

      def base_element
        @base_element ||= create_node(root, self.class.to_s)
      end

      def self.implement_methods
        # array of elements expected
        []
      end

      attr_reader *implement_methods unless implement_methods.size == 0

      implement_methods.each do |method|
        define_method("#{method=}") do |val|
          v = instance_variable_get("@#{method}")
          unless v
            v = create_node(base_element, snake_case_to_camel_case(method))
          end
          instance_variable_set("@#{method}", val)
          v.content = val
        end
      end
    end
  end
end