# Copyright 2013, Dell
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
class CreateBarclampsAttribs < ActiveRecord::Migration
  def change
    create_table(:barclamp_attribs, :primary_key=>:generated_id, :id=>false) do |t|
      t.integer     :generated_id,  :null=>true # manually generated!  not the auto ID propoerty
      t.string      :name,          :null=>false
      t.string      :description
      t.integer     :order,         :null=>false, :default=>10000
      t.belongs_to  :barclamp,      :null=>false
      t.belongs_to  :attrib,        :null=>false
      t.timestamps      
    end
    #natural key
    add_index(:barclamp_attribs,    [:name],                        :unique => true)   
    add_index(:barclamp_attribs,    [:barclamp_id, :attrib_id],     :unique => true)   
  end
    
end
