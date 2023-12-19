pageextension 50092 ServiceOrderSubForm extends "Service Order Subform"
{
    layout
    {

        addafter(Description)
        {
            field(Mileage; Rec.Mileage)
            {
                ApplicationArea = All;
            }
        }
    }
}