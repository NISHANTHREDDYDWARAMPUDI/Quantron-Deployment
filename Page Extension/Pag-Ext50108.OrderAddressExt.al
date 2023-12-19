pageextension 50108 OrderAddressEXt extends "Order Address"
{
    layout
    {
        addafter("Last Date Modified")
        {

            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = VAT;
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
                trigger OnDrillDown()
                var
                    VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
                begin
                    AssistEditOrderAddressVATReg(Rec);
                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    procedure AssistEditOrderAddressVATReg(OrderAddress: Record "Order Address")
    var
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        CheckAndLogUnloggedVATRegistrationNumbers(VATRegistrationLog, VATRegistrationLog."Account Type"::"Order Address", OrderAddress."Vendor No.");
        Page.RunModal(Page::"VAT Registration Log", VATRegistrationLog);
    end;

    local procedure CheckAndLogUnloggedVATRegistrationNumbers(var VATRegistrationLog: Record "VAT Registration Log"; AccountType: Enum "VAT Registration Log Account Type"; AccountNo: Code[20])
    begin
        VATRegistrationLog.SetRange("Account Type", AccountType);
        VATRegistrationLog.SetRange("Account No.", AccountNo);
        if VATRegistrationLog.IsEmpty() then
            LogUnloggedVATRegistrationNumbers();
    end;

    local procedure LogUnloggedVATRegistrationNumbers()
    var

        OrderAddress: Record "Order Address";
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        OrderAddress.SetFilter("VAT Registration No.", '<>%1', '');
        if OrderAddress.FindSet() then
            repeat
                VATRegistrationLog.SetRange("VAT Registration No.", OrderAddress."VAT Registration No.");
                if VATRegistrationLog.IsEmpty() then
                    OrderAddress.LogOrderAddress(OrderAddress);
            until OrderAddress.Next() = 0;
    end;


}