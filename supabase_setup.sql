-- ╔══════════════════════════════════════════════╗
-- ║  SUPABASE SETUP — Escuta Organizacional      ║
-- ║  Execute no SQL Editor do Supabase           ║
-- ╚══════════════════════════════════════════════╝

-- 1. Tabela de métricas (uma única linha)
CREATE TABLE IF NOT EXISTS eo_metricas (
  id         integer PRIMARY KEY DEFAULT 1,
  acessos    integer DEFAULT 0,
  iniciados  integer DEFAULT 0,
  concluidos integer DEFAULT 0
);
INSERT INTO eo_metricas (id) VALUES (1) ON CONFLICT DO NOTHING;

-- 2. Tabela de respostas
CREATE TABLE IF NOT EXISTS eo_respostas (
  id         uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at timestamptz DEFAULT now(),
  q1  text, q2  text, q3  text, q4  text,
  q5  text, q6  text, q7  text, q8  text,
  q9  text, q10 text, q11 text, q12 text,
  q13 text, q14 text, q15 text, q16 text,
  q17 text, q18 text, q19 text, q20 integer
);

-- 3. Habilita Row Level Security
ALTER TABLE eo_metricas  ENABLE ROW LEVEL SECURITY;
ALTER TABLE eo_respostas ENABLE ROW LEVEL SECURITY;

-- 4. Políticas — acesso público (formulário anônimo)
CREATE POLICY "public_read_metricas"   ON eo_metricas  FOR SELECT USING (true);
CREATE POLICY "public_update_metricas" ON eo_metricas  FOR UPDATE USING (true);
CREATE POLICY "public_read_respostas"  ON eo_respostas FOR SELECT USING (true);
CREATE POLICY "public_insert_respostas"ON eo_respostas FOR INSERT WITH CHECK (true);
CREATE POLICY "public_delete_respostas"ON eo_respostas FOR DELETE USING (true);

-- 5. Função RPC para incrementar métrica com segurança
CREATE OR REPLACE FUNCTION incrementar_metrica(coluna text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF coluna = 'acessos'    THEN UPDATE eo_metricas SET acessos    = acessos    + 1 WHERE id = 1;
  ELSIF coluna = 'iniciados'   THEN UPDATE eo_metricas SET iniciados   = iniciados   + 1 WHERE id = 1;
  ELSIF coluna = 'concluidos'  THEN UPDATE eo_metricas SET concluidos  = concluidos  + 1 WHERE id = 1;
  END IF;
END;
$$;
