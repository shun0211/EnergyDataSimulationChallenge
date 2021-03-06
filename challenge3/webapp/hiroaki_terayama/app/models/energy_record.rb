class EnergyRecord < ApplicationRecord
  belongs_to :house

  validates :origin_id, presence: true, uniqueness: true, numericality: { only_integer: true }
  validates :label, presence: true, numericality: { only_integer: true }
  validates :house_origin_id, presence: true, numericality: { only_integer: true }
  validates :year, presence: true, numericality: { only_integer: true }, length: { is: 4 }
  validates :month, presence: true, numericality: { only_integer: true }, length: { in: 1..2 }
  validates :temperature, presence: true, numericality: { only_integer: false }
  validates :daylight, presence: true, numericality: { only_integer: false }
  validates :energy_production, presence: true

  scope :with_house, -> { joins(:house) }
  scope :search_by_city, -> (city) { with_house.merge(House.where(city: city)) }

  def self.get_attributes(row)
    {
        origin_id: row['ID'].to_i,
        label: row['Label'].to_i,
        house_origin_id: row['House'].to_i,
        year: row['Year'].to_i,
        month: row['Month'].to_i,
        temperature: row['Temperature'].to_f,
        daylight: row['Daylight'].to_f,
        energy_production: row['EnergyProduction'].to_i,
        house_id: House.find_by(origin_id: row['House'].to_i)&.id
    }
  end
end
