import Quick
import Nimble
import Where_I_Work
import CoreData

@testable import Where_I_Work

class AddressSpec: QuickSpec {
    override func spec() {
        var address: Address!
        var context: NSManagedObjectContext!
        beforeEach{
            context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            
            let entity =  NSEntityDescription.entityForName("AddressTest", inManagedObjectContext: context)!
            address = Address(entity: entity, insertIntoManagedObjectContext: context)
            address.street = "123 Main"
            address.city = "Any City"
            address.zipCode = "12345"
            address.state = "NC"
//            address = Address(street: "123 Main", city: "Any City", zip: "12345", state: "NC", context: context)
        }
        describe("get Address Display String"){
            it("should return the line breaks when includeNewLine is true"){
                let expected = ""
                let actual = address.getAddressDisplayString(true)
                
                expect(actual).to(be(expected))
            }
            
            it("should pass"){
                expect(true).to(beTrue())
            }
            
            it("should fail"){
                expect(false).to(beTrue())
            }
        }
    }
}
