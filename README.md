Salesforce Lightning Web Component table that can be used in the Lightning App Builder or Community Builder and is driven off of a field set and object API name.

# Types of Lists
* List
    * a list of any records in the system
    * provide the Sobject API name and Field Set name
* Related List
    * a list of any related records to a parent record
    * provide the Sobject API name, Field Set name, and Sobject Lookup Field API Name
* Filtered List
    * a list of any records filted by a SOQL WHERE statement 
    * provide the Sobject API name, Field Set name, and Additional Where Clause
* Filtered Related List
    * a list of filtered related records to a parent record
    * Rendered if all attributes are filled out

# Configure Components
## Drag Components onto a page
This component works on app pages, record pages, home pages, and community pages.

Here is a table breakdown of what lists work on what pages:

|   | App Pages  | Record Pages  | Home Pages  | Community Pages  |
|:-:|:-:|:-:|:-:|:-:|
| Lists  | X  |   | X  | X  |
| Related Lists  | X  | X  | X  | X  |
| Filtered Lists  | X  | X  | X  | X  |
| Filtered Related Lists  | X  | X  | X  | X  |

# Edit the attributes
* Object API Name - The API name of the object where the layout was placed (Community Record Page only)
* Field Set API Name - API name of the field set on the Object API Name
* sObject Lookup Field API Name - API name of the sObject field used in a lookup or master-detail relationship 
    * sObject API Name ==> sObject Lookup Field API Name
    * Contact ==> AccountId
    * Contact ==> AccountId
    * Opportunity ==> AccountId
* (Additional) WHERE Clause in SOQL Query - optional filtering statement for WHERE clause in SOQL queries

# Example Uses
