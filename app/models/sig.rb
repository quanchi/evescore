class Sig < ActiveRecord::Base
  belongs_to :scan
  belongs_to :char
  belongs_to :corp
  belongs_to :solar_system, foreign_key: :system_id
  belongs_to :cons
  belongs_to :region
  belongs_to :alliance
  belongs_to :sig_type
  belongs_to :sig_group
end
