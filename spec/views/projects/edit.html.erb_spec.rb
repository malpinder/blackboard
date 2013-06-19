require 'spec_helper'

describe "projects/edit" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :group_id => 1,
      :name => "MyString",
      :summary => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", project_path(@project), "post" do
      assert_select "select#project_group_id[name=?]", "project[group_id]"
      assert_select "input#project_name[name=?]", "project[name]"
      assert_select "input#project_summary[name=?]", "project[summary]"
      assert_select "textarea#project_description[name=?]", "project[description]"
    end
  end
end
