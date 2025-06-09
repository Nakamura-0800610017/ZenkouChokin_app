class UserPoint < ApplicationRecord
  enum user_rank: { nomal: 0, danka: 1, syugyousou: 2, souryo: 3, ajyari: 4, arakan: 5,
                    ten: 6, myouou: 7, bosatu: 8, daibutu: 9 }

  belongs_to :user

  BORDER_POINT = [ [ :danka, 25 ], [ :syugyousou, 150 ], [ :souryo, 400 ], [ :ajyari, 800 ], [ :arakan, 1500 ],
                [ :ten, 3000 ], [ :myouou, 5000 ], [ :bosatu, 7500 ], [ :daibutu, 10000 ] ].freeze

  def update_rank!
    array = BORDER_POINT.reverse
    array.each do |rank, point|
      if total_points >= point
        self.user_rank = rank
        return
      end
    end
    self.user_rank = :nomal
  end
end
