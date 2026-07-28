-- 1) settlements table
CREATE TABLE public.supplier_settlements (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  reference_number text,
  notes text,
  receipt_image text,
  transaction_count integer NOT NULL DEFAULT 0,
  total_amount numeric NOT NULL DEFAULT 0,
  settled_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

GRANT SELECT, INSERT, UPDATE, DELETE ON public.supplier_settlements TO authenticated;
GRANT ALL ON public.supplier_settlements TO service_role;

ALTER TABLE public.supplier_settlements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins manage supplier_settlements"
  ON public.supplier_settlements
  FOR ALL
  TO authenticated
  USING (public.has_role(auth.uid(), 'admin'::app_role))
  WITH CHECK (public.has_role(auth.uid(), 'admin'::app_role));

CREATE TRIGGER trg_supplier_settlements_updated_at
  BEFORE UPDATE ON public.supplier_settlements
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- 2) link payments to a settlement
ALTER TABLE public.payments
  ADD COLUMN settlement_id uuid REFERENCES public.supplier_settlements(id) ON DELETE SET NULL,
  ADD COLUMN settled_at timestamptz;

CREATE INDEX idx_payments_settlement_id ON public.payments(settlement_id);
