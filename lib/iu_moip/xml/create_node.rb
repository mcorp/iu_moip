module IuMoip
  class XML
    module CreateNode
      def create_node(store, name, *args)
        var = doc.create_element(name, *args)
        store.add_child(var)
        var
      end

      def set_node(root, field, val)
        v = instance_variable_get("@#{field}")
        unless v
          v = create_node(root, field)
          root.add_child(v)
        end
        instance_variable_set("@#{field}", val)
        v.content = val
      end

      def snake_case_to_camel_case(val)
        val.to_s.split('_').map{ |i| format_word(i) }.join('')
      end

      def format_word(word)
        return word.upcase if ['url', 'cep'].include?(word.downcase)
        word.capitalize
      end
    end
  end
end