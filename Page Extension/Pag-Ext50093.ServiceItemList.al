pageextension 50093 ServiceItemList extends "Service Item List"
{
    layout
    {
        addafter("Serial No.")
        {
            field("Plate No."; Rec."Plate No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Plate No. of the vehicle.';
            }
        }
        addlast(Control1)
        {

            field(Address; Rec.Address)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the address of the customer who owns this item.';
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies additional address information.';
            }
            field(Brand; Rec.Brand)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the Brand name';
            }
            field(City; Rec.City)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the city of the customer address.';
            }
            field(Comment; Rec.Comment)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Comment field.';
            }
            field(Contact; Rec.Contact)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the name of the person you regularly contact when you do business with the customer who owns this item.';
            }
            field("Contract Cost"; Rec."Contract Cost")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Contract Cost field.';
            }
            field("Cost Used"; Rec."Cost Used")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Cost Used field.';
            }
            field("Country/Region Code"; Rec."Country/Region Code")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the country/region of the address.';
            }
            field(County; Rec.County)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the state, province or county as a part of the address.';
            }
            field("Default Contract Cost"; Rec."Default Contract Cost")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the default contract cost of a service item that later will be included in a service contract or contract quote.';
            }
            field("Default Contract Discount %"; Rec."Default Contract Discount %")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies a default contract discount percentage for an item, if this item will be part of a service contract.';
            }
            field("Default Contract Value"; Rec."Default Contract Value")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the default contract value of an item that later will be included in a service contract or contract quote.';
            }
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Description 2 field.';
            }
            field("Invoiced Amount"; Rec."Invoiced Amount")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Invoiced Amount field.';
            }
            field("Item Description 2"; Rec."Item Description 2")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Item Description 2 field.';
            }
            field("KM-Status"; Rec."KM-Status")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the actual KM status';
            }
            field("Location of Service Item"; Rec."Location of Service Item")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the code of the location of this item.';
            }
            field(Model; Rec.Model)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the model';
            }
            field(Name; Rec.Name)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the name of the customer who owns this item.';
            }
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Name 2 field.';
            }
            field("No. of Active Contracts"; Rec."No. of Active Contracts")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the No. of Active Contracts field.';
            }
            field("No. Series"; Rec."No. Series")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the No. Series field.';
            }
            field("Parts Used"; Rec."Parts Used")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Parts Used field.';
            }
            field("Phone No."; Rec."Phone No.")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the customer phone number.';
            }
            field("Post Code"; Rec."Post Code")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the postal code.';
            }
            field("Preferred Resource"; Rec."Preferred Resource")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the number of the resource that the customer prefers for servicing of the item.';
            }
            field("Prepaid Amount"; Rec."Prepaid Amount")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Prepaid Amount field.';
            }
            field("Prod. Order Line No."; Rec."Prod. Order Line No.")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Prod. Order Line No. field.';
            }
            field("Prod. Order No."; Rec."Prod. Order No.")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Prod. Order No. field.';
            }
            field("Reg. Date"; Rec."Reg. Date")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the registration Date.';
            }
            field("Resources Used"; Rec."Resources Used")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Resources Used field.';
            }
            field("Response Time (Hours)"; Rec."Response Time (Hours)")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the estimated number of hours this item requires before service on it should be started.';
            }
            field("Sales Date"; Rec."Sales Date")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the date when this item was sold.';
            }
            field("Sales Unit Cost"; Rec."Sales Unit Cost")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the unit cost of this item when it was sold.';
            }
            field("Sales Unit Price"; Rec."Sales Unit Price")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the unit price of this item when it was sold.';
            }
            field("Sales/Serv. Shpt. Document No."; Rec."Sales/Serv. Shpt. Document No.")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Sales/Serv. Shpt. Document No. field.';
            }
            field("Sales/Serv. Shpt. Line No."; Rec."Sales/Serv. Shpt. Line No.")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Sales/Serv. Shpt. Line No. field.';
            }
            field("Service Item Components"; Rec."Service Item Components")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies that there is a component for this service item.';
            }
            field("Service Item Group Code"; Rec."Service Item Group Code")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the code of the service item group associated with this item.';
            }
            field("Service Price Group Code"; Rec."Service Price Group Code")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the code of the Service Price Group associated with this item.';
            }
            field("Ship-to Address"; Rec."Ship-to Address")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the address that the items are shipped to.';
            }
            field("Ship-to Address 2"; Rec."Ship-to Address 2")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies an additional part of the ship-to address, in case it is a long address.';
            }
            field("Ship-to City"; Rec."Ship-to City")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the city of the address that the items are shipped to.';
            }
            field("Ship-to Contact"; Rec."Ship-to Contact")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the name of the contact person at the address that the items are shipped to.';
            }
            field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Ship-to Country/Region Code field.';
            }
            field("Ship-to County"; Rec."Ship-to County")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Ship-to County field.';
            }
            field("Ship-to Name"; Rec."Ship-to Name")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the name of the customer at the address that the items are shipped to.';
            }
            field("Ship-to Name 2"; Rec."Ship-to Name 2")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Ship-to Name 2 field.';
            }
            field("Ship-to Phone No."; Rec."Ship-to Phone No.")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the phone number at address that the items are shipped to.';
            }
            field("Ship-to Post Code"; Rec."Ship-to Post Code")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the postal code of the address that the items are shipped to.';
            }
            field("Shipment Type"; Rec."Shipment Type")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Shipment Type field.';
            }
            field(SP; Rec.SP)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the next SP-Date';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the SystemCreatedAt field.';
            }
            field(SystemCreatedBy; Rec.SystemCreatedBy)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the SystemCreatedBy field.';
            }
            field(SystemId; Rec.SystemId)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the SystemId field.';
            }
            field(SystemModifiedAt; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the SystemModifiedAt field.';
            }
            field(SystemModifiedBy; Rec.SystemModifiedBy)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the SystemModifiedBy field.';
            }
            field("Total Qty. Consumed"; Rec."Total Qty. Consumed")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Total Qty. Consumed field.';
            }
            field("Total Qty. Invoiced"; Rec."Total Qty. Invoiced")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Total Qty. Invoiced field.';
            }
            field("Total Quantity"; Rec."Total Quantity")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Total Quantity field.';
            }
            field("TÜV"; Rec."TÜV")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the TÜV Date.';
            }
            field("Unit of Measure Code"; Rec."Unit of Measure Code")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
            }
            field("Usage (Amount)"; Rec."Usage (Amount)")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Usage (Amount) field.';
            }
            field("Usage (Cost)"; Rec."Usage (Cost)")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Usage (Cost) field.';
            }
            field("Variant Code"; Rec."Variant Code")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the variant of the item on the line.';
            }
            field("Vendor Item Name"; Rec."Vendor Item Name")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the name assigned to this item by the vendor.';
            }
            field("Vendor Item No."; Rec."Vendor Item No.")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the number that the vendor uses for this item.';
            }
            field("Warranty % (Labor)"; Rec."Warranty % (Labor)")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the percentage of labor costs covered by the warranty for this item.';
            }
            field("Warranty % (Parts)"; Rec."Warranty % (Parts)")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the percentage of spare parts costs covered by the warranty for the item.';
            }
        }
    }
}
