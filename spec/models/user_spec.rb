require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many(:books).dependent(:destroy) }

  it { should validate_presence_of(:first_name) }
end
