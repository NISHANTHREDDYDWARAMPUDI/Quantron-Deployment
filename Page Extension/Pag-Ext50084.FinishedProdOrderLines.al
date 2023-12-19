pageextension 50084 FinishedProdOrderLines extends "Finished Prod. Order Lines"
{
    actions
    {
        addafter("Item &Tracking Lines")
        {
            action("Open Service Items")
            {
                ApplicationArea = All;
                Caption = 'Open Service Items';
                Image = ServiceItem;
                RunObject = page "Service Items";
                RunPageLink = "Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Line No.");
                RunPageMode = View;
            }
        }
    }
}
