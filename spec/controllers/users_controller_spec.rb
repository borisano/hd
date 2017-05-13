require 'rails_helper'
require 'spec_helper'

RSpec.describe UsersController, type: :controller do

  let(:user_role){ FactoryGirl.create(:role,{name:'admin'})}
  let!(:user){FactoryGirl.create(:user,role:user_role)}

  before(:each){
    @admin = User.new
    @admin.password ='123456'
    @admin.email = "testadmin@test.com"
    @admin.approved = true
    @admin_role = Role.find_by_name('admin')
    @admin.role = @admin_role
    @admin.avatar = Rails.root.join("spec/fixtures/binaries/headshots/adam_west.jpg").open
    @admin.save!
    sign_in @admin
 }

  describe "GET #index users" do
    it "assign all users as @users" do
      get :index
      expect(assigns(:users)).to include(user,@admin)
    end
    it "renders the :index template" do
      get :index
      expect(response).to render_template("index")
    end
    #TODO remove this. This is an unnecessary test
    it "renders the :index template" do
      expect(@admin.avatar_identifier).to eq("adam_west.jpg")
    end
  end

end
