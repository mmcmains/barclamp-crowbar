# Copyright 2012, Dell 
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 
#  http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 
# 
require 'test_helper'
require 'json'

class JigModelTest < ActiveSupport::TestCase


  test "Unique Name" do
    Jig.create! :name=>"nodups", :type=>"JigTest", :description=>"unit tests"
    e = assert_raise(ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique, SQLite3::ConstraintException) { Jig.create!(:name => "nodups") }
    assert_equal "Validation failed: Name Item must be un...", e.message.truncate(42)
    assert_raise(ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique, SQLite3::ConstraintException) { b = Node.create! :name => "nodups" }
  end

  test "Naming Conventions" do
    assert_raise(ActiveRecord::RecordInvalid) { Jig.create!(:name=>"1123", :type=>"JigTest")}
    assert_raise(ActiveRecord::RecordInvalid) { Jig.create!(:name=>"1foo", :type=>"JigTest")}
    assert_raise(ActiveRecord::RecordInvalid) { Jig.create!(:name=>"Ille!gal", :type=>"JigTest")}
    assert_raise(ActiveRecord::RecordInvalid) { Jig.create!(:name=>" nospaces", :type=>"JigTest")}
    assert_raise(ActiveRecord::RecordInvalid) { Jig.create!(:name=>"no spaces", :type=>"JigTest")}
    assert_raise(ActiveRecord::RecordInvalid) { Jig.create!(:name=>"nospacesatall ", :type=>"JigTest")}
  end

  test "Must have override object-missing" do
     Jig.create!(:name=>"foo", :type=>"JigFoo")
     e = assert_raise(ActiveRecord::SubclassNotFound) { Jig.find_by_name "foo" }
     assert_equal "The single-table inheritance mechanism failed...", e.message.truncate(48)
  end

  test "Must have override object - present" do
     c = Jig.create! :name=>"subclass", :type=>"JigTest"
     assert_equal false, c.nil?
     assert_equal c.name, "subclass"
     assert_equal c.type, "JigTest"
  end
  
  test "Returns correct objective type" do
    c = Jig.create! :name=>"type_test", :type=>"JigTest"
    t = Jig.find_by_name "type_test"
    assert_equal c.type, t.type
    assert_equal t.type, "JigTest"
    assert_kind_of Jig, c
  end
  
  test "as_json routines returns correct items" do
    name = "json_test"
    type = "JigTest"
    description = "This is a unit test"
    c = Jig.create! :name=>name, :type=>type, :description => description, :order => 100
    j = JSON.parse(c.to_json)
    assert_equal j['type'], type
    assert_equal j['name'], name
    assert_equal j['description'], description
    assert_equal j['order'], 100
    assert_not_nil j['created_at']
    assert_not_nil j['updated_at']
    assert_equal j.length, 7
  end

  test "create event for jig with run" do
    j = JigTest.create :name=>"test"
    assert_not_nil j
    r = j.run
    assert_not_nil r
    assert_equal j, r.event.jig
    assert_equal 1, r.event.runs.count
  end
  
  test "Jig event is the right subtype" do
  end
  
end

