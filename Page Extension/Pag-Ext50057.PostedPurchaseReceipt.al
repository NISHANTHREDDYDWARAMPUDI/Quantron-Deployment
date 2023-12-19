pageextension 50057 PostedPurchaseReceipt extends "Posted Purchase Receipt"
{
    actions
    {
        addafter("&Print")
        {
            action(Transfer)
            {
                ApplicationArea = All;
                Caption = '&Transfer Material';
                Ellipsis = true;
                Image = PostDocument;

                trigger OnAction()
                var
                    ConfirmLbl: Label 'Do you want to transfer the material to new location?.';
                begin
                    if not Confirm(ConfirmLbl) then
                        exit;
                    CheckQualityCheck();
                    Rec.ProcessMaterialTransfer();
                end;
            }
        }
        addafter("&Print_Promoted")
        {
            actionref(Transfer_Promoted; Transfer)
            {
            }
        }
    }
    local procedure CheckQualityCheck()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        QualityCheckErr: Label 'Quantity cannot be transfered as the quality check is enable and quality specification is not completed for \ item no. : %1 & line no. %2';
    begin
        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Document No.", Rec."No.");
        PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
        PurchRcptLine.SetRange("Quality Check", true);
        PurchRcptLine.SetRange("Quality Check Completed", false);
        PurchRcptLine.SetFilter("New Location Code", '<>%1', '');
        if PurchRcptLine.FindFirst() then
            Error(QualityCheckErr, PurchRcptLine."No.", PurchRcptLine."Line No.");
    end;
}
