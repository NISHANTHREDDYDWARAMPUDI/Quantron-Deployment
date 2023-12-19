pageextension 50060 CurrenciesExt extends Currencies
{
    layout
    {
        addafter(Code)
        {
            field(Symbol; Rec.Symbol)
            {
                ApplicationArea = All;
            }
        }
    }
}
