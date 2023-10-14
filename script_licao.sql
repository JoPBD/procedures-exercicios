-- EX 01
CREATE TABLE IF NOT EXISTS tb_log(
	cod_log SERIAL PRIMARY KEY,
	data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	operacao_realizada VARCHAR(50)
);

DROP PROCEDURE sp_registrar_operacao_historico;
CREATE OR REPLACE PROCEDURE sp_registrar_operacao_historico(IN data_op TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
															IN proc_exec TEXT DEFAULT 'NA',
														   	IN cod_log INT DEFAULT NULL)
LANGUAGE plpgsql
AS $$ 
BEGIN
	IF cod_log IS NULL THEN
		INSERT INTO tb_log(data_operacao, operacao_realizada) VALUES(data_op, proc_exec);
	ELSE
		INSERT INTO tb_log(cod_log, data_operacao, operacao_realizada) VALUES
		(cod_log, data_op, proc_exec);
	END IF;
END;
$$

CALL sp_registrar_operacao_historico('10-10-1999', 'INSERT');
CALL sp_registrar_operacao_historico('10-10-2000', 'UPDATE',2);
SELECT * FROM tb_log;

DO 
$$
DECLARE
	data_op TIMESTAMP := '10-10-2010';
	proc_exec VARCHAR := 'INSERT';
BEGIN
	CALL sp_registrar_operacao_historico(data_op, proc_exec);
	RAISE NOTICE 'Resgistro realizado com sucesso!';
END;
$$