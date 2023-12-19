tableextension 50044 ServiceItemComponent extends "Service Item Component"
{
    fields
    {
         //QTD-00006>>
         field(50000; "Purchase Recepit Date"; Date)
        {
            Caption = 'Purchase Recepit Date';
            DataClassification = CustomerContent;
        }
         //QTD-00006>>

    }
}