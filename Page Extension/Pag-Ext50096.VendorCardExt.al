pageextension 50096 VendorCardExt extends "Vendor Card"
{
    layout
    {
        modify("Privacy Blocked")
        {
            Editable = EditVendorBlock;
        }
    }
    trigger OnAfterGetRecord()
    begin
        EditVendorBlock := false;
        if not UsersetupRec.Get(UserId) then
            Clear(UsersetupRec);
        EditVendorBlock := UsersetupRec."Vendor Privacy Block";
    end;

    trigger OnOpenPage()
    begin
        EditVendorBlock := false;
        if not UsersetupRec.Get(UserId) then
            Clear(UsersetupRec);
        EditVendorBlock := UsersetupRec."Vendor Privacy Block";
    end;

    var
        EditVendorBlock: Boolean;
        UsersetupRec: record "User Setup";
}