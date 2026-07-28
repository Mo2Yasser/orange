-- Full Combined Database Schema for Arabyan Pay / Net Landline
-- Execute this script in SQL Editor on your new Supabase project

-- 1) Public tables & ENUMs
CREATE TYPE public.app_role AS ENUM ('admin', 'user');

CREATE TABLE public.app_settings (
  id integer PRIMARY KEY DEFAULT 1,
  receiving_number text DEFAULT '',
  brand_name text DEFAULT 'نت الأرضي',
  packages jsonb DEFAULT '[]'::jsonb,
  receiving_description text DEFAULT '',
  receiving_image text DEFAULT '',
  reminder_template text DEFAULT '',
  payment_link text DEFAULT '',
  payment_methods jsonb DEFAULT '[]'::jsonb,
  supplier_fee_default numeric NOT NULL DEFAULT 100,
  supplier_fee_overrides jsonb NOT NULL DEFAULT '[]'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE public.customers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  landline text UNIQUE NOT NULL,
  whatsapp text NOT NULL,
  package text NOT NULL,
  renewal_day integer NOT NULL DEFAULT 1,
  myorange_phone text,
  myorange_password text,
  notes text,
  renewed_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE public.supplier_settlements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reference_number text,
  notes text,
  receipt_image text,
  transaction_count integer NOT NULL DEFAULT 0,
  total_amount numeric NOT NULL DEFAULT 0,
  settled_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid REFERENCES public.customers(id) ON DELETE SET NULL,
  landline text NOT NULL,
  whatsapp text NOT NULL,
  amount numeric NOT NULL,
  from_number text NOT NULL,
  notes text,
  proof_image text,
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'refunded')),
  submitted_at timestamptz DEFAULT now(),
  reviewed_at timestamptz,
  rejection_reason text,
  settlement_id uuid REFERENCES public.supplier_settlements(id) ON DELETE SET NULL,
  settled_at timestamptz
);

CREATE TABLE public.inquiries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  landline text NOT NULL,
  whatsapp text NOT NULL,
  message text NOT NULL,
  proof_image text,
  status text DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);

CREATE TABLE public.user_roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  role public.app_role NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE public.error_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  error_message text,
  context text,
  created_at timestamptz DEFAULT now()
);

-- Realtime & Security
ALTER TABLE public.customers REPLICA IDENTITY FULL;
ALTER TABLE public.payments REPLICA IDENTITY FULL;
ALTER TABLE public.inquiries REPLICA IDENTITY FULL;
ALTER TABLE public.supplier_settlements REPLICA IDENTITY FULL;
ALTER TABLE public.app_settings REPLICA IDENTITY FULL;
