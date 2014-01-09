require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ResearchAssistantsController do

  # This should return the minimal set of attributes required to create a valid
  # ResearchAssistant. As you add validations to ResearchAssistant, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "firstname" => "Jane", "lastname" => "Doe", "role" => Role.create(:name => "Research Assistant"), "identity_url" => "af", "email" => "test@example"} }

  # Programming Languages with a mapping to skill integers
  let(:programming_languages_attributes) { { "1" => "5", "2" => "2" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ResearchAssistantsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all research_assistants as @research_assistants" do
      research_assistant = User.create! valid_attributes
      get :index, {}, valid_session
      assigns(:users).should eq([research_assistant])
    end
  end

  describe "GET show" do
    it "assigns the requested research_assistant as @research_assistant" do
      user = User.create! valid_attributes
      get :show, {:id => user.to_param}, valid_session
      assigns(:user).should eq(user)
    end
  end

  #describe "GET new" do
  #  it "assigns a new research_assistant as @research_assistant" do
  #    get :new, {}, valid_session
  #    assigns(:research_assistant).should be_a_new(ResearchAssistant)
  #  end
  #end

  describe "GET edit" do
    it "assigns the requested research_assistant as @research_assistant" do
      research_assistant = User.create! valid_attributes
      get :edit, {:id => research_assistant.to_param}, valid_session
      assigns(:user).should eq(research_assistant)
    end
  end

  # describe "POST create" do
  #   describe "with valid params" do
  #     it "creates a new ResearchAssistant" do
  #       expect {
  #         post :create, {:research_assistant => valid_attributes}, valid_session
  #       }.to change(ResearchAssistant, :count).by(1)
  #     end

  #     it "assigns a newly created research_assistant as @research_assistant" do
  #       post :create, {:research_assistant => valid_attributes}, valid_session
  #       assigns(:research_assistant).should be_a(ResearchAssistant)
  #       assigns(:research_assistant).should be_persisted
  #     end

  #     it "redirects to the created research_assistant" do
  #       post :create, {:research_assistant => valid_attributes}, valid_session
  #       response.should redirect_to(ResearchAssistant.last)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved research_assistant as @research_assistant" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       ResearchAssistant.any_instance.stub(:save).and_return(false)
  #       post :create, {:research_assistant => {  }}, valid_session
  #       assigns(:research_assistant).should be_a_new(ResearchAssistant)
  #     end

  #     it "re-renders the 'new' template" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       ResearchAssistant.any_instance.stub(:save).and_return(false)
  #       post :create, {:research_assistant => {  }}, valid_session
  #       response.should render_template("new")
  #     end
  #   end
  # end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested research_assistant" do
        research_assistant = User.create! valid_attributes
        # Assuming there are no other research_assistants in the database, this
        # specifies that the ResearchAssistant created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        User.any_instance.should_receive(:update).with({ "firstname" => "MyString" })
        put :update, {:id => research_assistant.to_param, :user => { "firstname" => "MyString" }}, valid_session
      end

      it "assigns the requested research_assistant as @research_assistant" do
        research_assistant = User.create! valid_attributes
        put :update, {:id => research_assistant.to_param, :user => valid_attributes}, valid_session
        assigns(:user).should eq(research_assistant)
      end

      it "redirects to the research_assistant" do
        research_assistant = User.create! valid_attributes
        put :update, {:id => research_assistant.to_param, :user => valid_attributes}, valid_session
        response.should redirect_to(research_assistant_path(research_assistant))
      end
    end

    describe "with invalid params" do
      it "assigns the research_assistant as @research_assistant" do
        research_assistant = User.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => research_assistant.to_param, :user => { "firstname" => "invalid value" }}, valid_session
        assigns(:user).should eq(research_assistant)
      end

      it "re-renders the 'edit' template" do
        research_assistant = User.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => research_assistant.to_param, :user => { "firstname" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested research_assistant" do
      research_assistant = User.create! valid_attributes
      expect {
        delete :destroy, {:id => research_assistant.to_param}, valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the research_assistants list" do
      research_assistant = User.create! valid_attributes
      delete :destroy, {:id => research_assistant.to_param}, valid_session
      response.should redirect_to(research_assistants_path)
    end
  end
  
  describe "PUT update with programming languages skills" do
    before(:each) do
      @research_assistant = FactoryGirl.create(:user, valid_attributes)
      @programming_language_1 = FactoryGirl.create(:programming_language, name: 'Java')
      @programming_language_2 = FactoryGirl.create(:programming_language, name: 'Go')
    end
    it "updates the requested research assistant with an existing programming language" do
      @research_assistant.assign_attributes(:programming_languages_users => [FactoryGirl.create(:programming_languages_user, user: @research_assistant, programming_language: @programming_language_1, skill: '4')])
      @research_assistant.programming_languages_users.size.should eq(1)
      ProgrammingLanguagesUser.any_instance.should_receive(:update_attributes).with({ :skill => "2" })
      put :update, {:id => @research_assistant.to_param, :user => { "firstname" => "Max" }, :programming_languages => { @programming_language_1.id.to_s => "2" }}, valid_session
    end
    it "updates the requested research assistant with a new programming language" do
      @research_assistant.assign_attributes(:programming_languages_users => [FactoryGirl.create(:programming_languages_user, user: @research_assistant, programming_language: @programming_language_1, skill: '4')])
      put :update, {:id => @research_assistant.to_param, :user => { "firstname" => "Max" }, :programming_languages => { @programming_language_1.id.to_s => "4", @programming_language_2.id.to_s => "2" }}, valid_session
      @research_assistant.reload
      @research_assistant.programming_languages_users.size.should eq(2)
      @research_assistant.programming_languages.first.should eq(@programming_language_1)
      @research_assistant.programming_languages.last.should eq(@programming_language_2)
    end
    it "updates the requested research assistant with a removed programming language" do
      @research_assistant.assign_attributes(:programming_languages_users => [FactoryGirl.create(:programming_languages_user, user: @research_assistant, programming_language: @programming_language_1, skill: '4'), FactoryGirl.create(:programming_languages_user, programming_language_id: @programming_language_2.id, skill: '2')])
      put :update, {:id => @research_assistant.to_param, :user => { "firstname" => "Max" }, :programming_languages => { @programming_language_1.id.to_s => "2" }}, valid_session
      @research_assistant.reload
      @research_assistant.programming_languages_users.size.should eq(1)
      @research_assistant.programming_languages.first.should eq(@programming_language_1)
    end
  end

  describe "PUT update with languages skills" do
    before(:each) do
      @research_assistant = FactoryGirl.create(:user, valid_attributes)
      @language_1 = FactoryGirl.create(:language, name: 'English')
      @language_2 = FactoryGirl.create(:language, name: 'German')
    end
    it "updates the requested research assistant with an existing language" do
      @research_assistant.assign_attributes(:languages_users => [FactoryGirl.create(:languages_user, user: @research_assistant, language: @language_1, skill: '4')])
      @research_assistant.languages_users.size.should eq(1)
      LanguagesUser.any_instance.should_receive(:update_attributes).with({ :skill => "2" })
      put :update, {:id => @research_assistant.to_param, :user => { "firstname" => "Max" }, :languages => { @language_1.id.to_s => "2" }}, valid_session
    end
    it "updates the requested research assistant with a new language" do
      @research_assistant.assign_attributes(:languages_users => [FactoryGirl.create(:languages_user, user: @research_assistant, language: @language_1, skill: '4')])
      put :update, {:id => @research_assistant.to_param, :user => { "firstname" => "Max" }, :languages => { @language_1.id.to_s => "4", @language_2.id.to_s => "2" }}, valid_session
      @research_assistant.reload
      @research_assistant.languages_users.size.should eq(2)
      @research_assistant.languages.first.should eq(@language_1)
      @research_assistant.languages.last.should eq(@language_2)
    end
    it "updates the requested research assistant with a removed language" do
      @research_assistant.assign_attributes(:languages_users => [FactoryGirl.create(:languages_user, user: @research_assistant, language: @language_1, skill: '4'), FactoryGirl.create(:languages_user, language_id: @language_2.id, skill: '2')])
      put :update, {:id => @research_assistant.to_param, :user => { "firstname" => "Max" }, :languages => { @language_1.id.to_s => "2" }}, valid_session
      @research_assistant.reload
      @research_assistant.languages_users.size.should eq(1)
      @research_assistant.languages.first.should eq(@language_1)
    end
  end
end
