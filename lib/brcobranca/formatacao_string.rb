require 'active_support/multibyte/chars'
require 'active_support/core_ext/string/filters'
require 'active_support/inflector'

$KCODE = 'UTF8'

module Brcobranca
  # Métodos auxiliares de formatação de strings
  module FormatacaoString
    # Copied from Rails3 sourcecode
    def truncate(length, options = {})
      text = self.dup
      options[:omission] ||= "..."

      length_with_room_for_omission = length - options[:omission].mb_chars.length
      chars = text.mb_chars
      stop = options[:separator] ?
        (chars.rindex(options[:separator].mb_chars, length_with_room_for_omission) || length_with_room_for_omission) : length_with_room_for_omission

      (chars.length > length ? chars[0...stop] + options[:omission] : text).to_s
    end
    # Formata o tamanho da string
    # para o tamanho passado
    # se a string for menor, adiciona espacos a direita
    # se a string for maior, trunca para o num. de caracteres
    #
    def format_size(size)
      if self.size > size
        ActiveSupport::Inflector.transliterate(truncate(size, :omission => '')).to_s
      else
        ActiveSupport::Inflector.transliterate(self).to_s.ljust(size, ' ')
      end
    end
  end
end

[String].each do |klass|
  klass.class_eval { include Brcobranca::FormatacaoString }
end
