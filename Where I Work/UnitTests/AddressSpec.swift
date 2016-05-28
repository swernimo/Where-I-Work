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
            context = NSManagedObjectContext(coder: NSCoder())
            address = Address(street: "123 Main", city: "Any City", zip: "12345", state: "NC", context: context)
        }
        describe("get Address Display String"){
            it("should return the line breaks when includeNewLine is return"){
                expect(false).to(beTrue())
            }
        }
    }
}
