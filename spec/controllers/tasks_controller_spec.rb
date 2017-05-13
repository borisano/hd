require 'rails_helper'
require 'spec_helper'

RSpec.describe TasksController, type: :controller do

  let(:user_role){ FactoryGirl.create(:role,{name:'admin'})}
  let!(:user){FactoryGirl.create(:user,role:user_role)}
  let!(:priority_high){FactoryGirl.create(:priority,name:'High')}
  let!(:status_triage){FactoryGirl.create(:status)}
  let!(:request_type_bug){FactoryGirl.create(:request_type)}
  let!(:vertical_production){FactoryGirl.create(:vertical)}

  let(:valid_attributes) {
    {
      title: "test task",
      description: "test description",
      reported_by_id: user.id,
      assigned_to_id: user.id,
      status_id: status_triage.id,
      request_type_id: request_type_bug.id,
      member_facing: true,
      vertical_id: vertical_production.id,
      link: "www.testlink.com",
      required_by: Date.today,
      priority_id: priority_high.id,
      attachments_attributes:[ {doc: fixture_file_upload('/binaries/cars/2.jpg','image/jpg', "true")},{doc: fixture_file_upload('/binaries/cars/1.jpg','image/jpg', "true")}]
    }
  }

  let(:invalid_attributes) {
    {
      title: "",
      price: "potato",
      content: "test content",
      image_attributes:{}
    }
  }

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

  describe "GET #index" do
    it "renders the :index template" do
      get :index
      expect(response).to render_template("index")
    end
    it "assign all tasks as @tasks" do
      get :index
      #expect(assigns(:tasks)).to include(user,@admin) TODO add tasks for index check
    end
  end

  describe "POST #create" do
    before(:each){
        allow_any_instance_of(Task).to receive(:send_slack).and_return(true)
    }
    context "with valid attributes" do

      it "saves the new task in the database" do
        expect { post :create, params: {task: valid_attributes} }.to change(Task, :count).by(1)
      end

      it "creates valid model attributes" do
        post :create, params: {task: valid_attributes}
        expect(assigns(:task).attachments.first.doc_identifier).to eq('2.jpg')
        expect(assigns(:task).priority.name).to eq('High')
        expect(assigns(:task).title).to eq('test task')
        expect(assigns(:task).required_by).to eq(Date.today)
      end

      it "redirects to tasks#show" do
        post :create, params: {task: valid_attributes}
        expect(response).to redirect_to(Task.last)
      end

      it "produces valid create flash message" do
        post :create, params: {task: valid_attributes}
        expect(flash[:notice]).to match("Task was successfully created.")
      end

    end

    context "with invalid attributes" do
      it "does not save the new task in the database" do
        expect { post :create, params: {task: invalid_attributes}}.to change(Task, :count).by(0)
      end
      it "renders the :new template" do
        post :create, params: {task: invalid_attributes}
        expect(response).to render_template("new")
      end
      it "assigns 2 error message" do
        post :create, params: {task: invalid_attributes}
        expect(assigns(:task).errors.size).to eq(1)
      end
      it "returns error message title 'can\'t be blank'" do
        post :create, params: {task: invalid_attributes}
        expect(assigns(:task).errors.messages[:description]).to match(["can't be blank"])
      end
    end
  end

  describe "DELETE #destroy" do

    it "destroys the requested task" do
      task_to_be_deleted = Task.create(valid_attributes)
      expect { delete :destroy, params: {id: task_to_be_deleted.id} }.to change(Task, :count).by(-1)
    end
    it "redirects to tasks" do
      task_to_be_deleted = Task.create(valid_attributes)
      delete :destroy, params: {id: task_to_be_deleted.id}
      expect(response).to redirect_to(tasks_url)
    end
    it "produces valid destroy flash message" do
      task_to_be_deleted = Task.create(valid_attributes)
      delete :destroy, params: {id: task_to_be_deleted.id}
      expect(flash[:notice]).to match("Task was successfully destroyed.")
    end

  end



end
