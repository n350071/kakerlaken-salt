require 'pry';

class Card
  attr_accessor :name, :g, :last, :called

  def initialize(name)
    @name = name
    @g = false
    @last = false
    @called = false
  end
end


class Table
  attr_accessor :cards

  def initialize
    # 🦄 Object Key Hash Pattern!
    @cards = {}
    [:paprika, :tomato, :cabbage, :cauliflower].each do |name|
      @cards[name]= Card.new(name)
    end
  end

  def reflesh_last_called_card
    @cards.select{|key, card| card.last == true}.each_value{|card| card.last = false}
    @cards.select{|key, card| card.called == true}.each_value{|card| card.called = false}
  end

  def put(card, call_card= nil)
    # rule1: not allowed double card
    # @cards.select{|key, card| card.last == true}.each_value{|card| card.last = false}
    @cards[card].last = true

    # rule3: if the card is called, it's not allwed until next card is called
    if call_card
      # @cards.select{|key, card| card.called == true}.each_value{|card| card.called = false}
      @cards[call_card].called = true
    end
  end

  def g(card)
    # rule2: G makes the card not allowed
    @cards.select{|key, card| card.g == true}.each_value{|card| card.g = false}
    @cards[card].g = true
  end

  def list
    available_cards = @cards.select do |key, card|
       card.g == false && card.last == false && card.called == false
     end
    available_cards.keys
  end

  def flash
    initialize
  end

  def e
    exit!
  end

  def arg_convert(num)
    case num.to_i
    when 1
      :paprika
    when 2
      :tomato
    when 3
      :cabbage
    when 4
      :cauliflower
    else
      nil
    end
  end

  def explain
    puts <<-EOF
      p1  -> put paprika
      p12 -> put paprika and call tomato
      g3  -> g cabbage
      ⭐️ means allowed vesitable
    EOF
  end

  def start
    loop do
      system "clear"
      puts <<-EOF
        1: #{'⭐️' if list.include?(:paprika)} paprika
        2: #{'⭐️' if list.include?(:tomato)} tomato
        3: #{'⭐️' if list.include?(:cabbage)} cabbage
        4: #{'⭐️' if list.include?(:cauliflower)} cauliflower
      EOF

      input = gets.chomp

      command,arg1,arg2 = input.split(//)

      case command
      when 'p'
        next unless [1,2,3,4].include?(arg1&.to_i)
        next unless [1,2,3,4,nil].include?(arg2&.to_i)
        reflesh_last_called_card
        put(arg_convert(arg1),arg_convert(arg2))
      when 'g'
        next unless [1,2,3,4].include?(arg1&.to_i)
        reflesh_last_called_card
        g(arg_convert(arg1))
      else
        # 🦄 show the instance_methods I defined
        unless self.class.instance_methods(false).include?(input.to_sym)
          puts "miss type💦"
          next
        end
        send(input)
      end
      # p list
    end
  end

end

table = Table.new()
table.start

# table.put(:paprika)
# p table.list
# table.g(:tomato)
# p table.list
# table.put(:tomato, :cabbage)
# p table.list
# table.flash
# p table.list


# cards = {
#   paprika: @card,
#   tomato: @card,
# }


# class AvailableCard
#   attr_accessor :paprika, :tomato, :cabbage, :cauliflower
#   def initialize
#     @paprika = true
#     @tomato = true
#     @cabbage = true
#     @cauliflower = true
#   end
#   def put(card)
#     self.send(card.to_s + '=', false)
#   end
#   def show
#     [paprika, tomato, cabbage, cauliflower].select{|v| v == true}
#   end
# end
# a_card = AvailableCard.new
# a_card.put(:paprika)
# a_card.show
#
