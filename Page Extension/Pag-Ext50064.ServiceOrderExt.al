pageextension 50064 "Service OrderExt" extends "Service Order"
{
    layout
    {
        addbefore("Shipping Time")
        {
            field("Package Tracking No"; Rec."Package Tracking No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Package Tracking No. field.';
            }
            field("Shipment date"; Rec."Shipment date")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            action("Service Proforma Invoice")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;
                PromotedIsBig = true;
                Image = Print;
                trigger OnAction()
                var
                    ServiceproformaInv: Report ServicePerformaInvoice;
                    ServiceheaderRec: Record "Service Header";
                begin
                    CurrPage.SetSelectionFilter(ServiceheaderRec);
                    ServiceproformaInv.SetTableView(ServiceheaderRec);
                    ServiceproformaInv.Run();
                end;
            }
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                DimensionErr: Label 'Both %1 & %2 is empty';
                Dimension2Err: Label 'Both %1 & %2 cannot be filled';
            begin
                rec.TestField("Posting Date");
                rec.TestField("Document Date");
                rec.TestField("VAT Reporting Date");

            end;
        }
        modify(Preview)
        {
            trigger OnBeforeAction()
            var
                DimensionErr: Label 'Both %1 & %2 is empty';
                Dimension2Err: Label 'Both %1 & %2 cannot be filled';
            begin
                rec.TestField("Posting Date");
                rec.TestField("Document Date");
                rec.TestField("VAT Reporting Date");
                if (Rec."Shortcut Dimension 1 Code" = '') and (Rec."Shortcut Dimension 2 Code" = '') then
                    Error(DimensionErr, Rec.FieldCaption("Shortcut Dimension 1 Code"), Rec.FieldCaption("Shortcut Dimension 2 Code"));
                if (Rec."Shortcut Dimension 1 Code" <> '') and (Rec."Shortcut Dimension 2 Code" <> '') then
                    Error(Dimension2Err, Rec.FieldCaption("Shortcut Dimension 1 Code"), Rec.FieldCaption("Shortcut Dimension 2 Code"));
            end;
        }

    }
}
