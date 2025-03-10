PGDMP     	    4                }            zeus_db_identity_provider     15.10 (Debian 15.10-1.pgdg120+1)     15.11 (Debian 15.11-1.pgdg120+1)     C           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            D           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            E           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            F           1262    16384    zeus_db_identity_provider    DATABASE        CREATE DATABASE zeus_db_identity_provider WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';
 )   DROP DATABASE zeus_db_identity_provider;
                admin    false                        2615    16386    idp_identity    SCHEMA        CREATE SCHEMA idp_identity;
    DROP SCHEMA idp_identity;
                admin    false                        3079    16387    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            G           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2            ύ            1255    16424    generate_ulid()    FUNCTION     Ύ  CREATE FUNCTION idp_identity.generate_ulid() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    timestamp_part TEXT;
    random_part TEXT;
    ulid TEXT;
BEGIN
    -- π Obtener el timestamp en milisegundos
    timestamp_part := lpad(to_hex((EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::bigint), 12, '0');

    -- π² Generar la parte aleatoria de 10 bytes y convertir a hex
    random_part := encode(gen_random_bytes(10), 'hex');

    -- π Concatenar timestamp + random para formar ULID
    ulid := upper(timestamp_part || random_part);

    -- π Asegurar que ULID tenga exactamente 26 caracteres (Base32 ULID usa 26)
    RETURN LEFT(ulid, 26);
END;
$$;
 ,   DROP FUNCTION idp_identity.generate_ulid();
       idp_identity          admin    false    7            Ψ            1259    16425    user    TABLE     J  CREATE TABLE idp_identity."user" (
    user_id character varying(26) DEFAULT idp_identity.generate_ulid() NOT NULL,
    record_status character varying(3) DEFAULT 'ACT'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by character varying(255) NOT NULL,
    updated_at timestamp without time zone,
    updated_by character varying(255),
    deleted_at timestamp without time zone,
    deleted_by character varying(255),
    transaction_id character varying(255),
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash text NOT NULL,
    is_active boolean DEFAULT true,
    CONSTRAINT user_record_status_check CHECK (((record_status)::text = ANY ((ARRAY['ACT'::character varying, 'DEL'::character varying])::text[])))
);
     DROP TABLE idp_identity."user";
       idp_identity         heap    admin    false    253    7            @          0    16425    user 
   TABLE DATA           Α   COPY idp_identity."user" (user_id, record_status, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by, transaction_id, username, email, password_hash, is_active) FROM stdin;
    idp_identity          admin    false    216          ­           2606    16440    user user_email_key 
   CONSTRAINT     W   ALTER TABLE ONLY idp_identity."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);
 E   ALTER TABLE ONLY idp_identity."user" DROP CONSTRAINT user_email_key;
       idp_identity            admin    false    216            ―           2606    16436    user user_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY idp_identity."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);
 @   ALTER TABLE ONLY idp_identity."user" DROP CONSTRAINT user_pkey;
       idp_identity            admin    false    216            ±           2606    16438    user user_username_key 
   CONSTRAINT     ]   ALTER TABLE ONLY idp_identity."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);
 H   ALTER TABLE ONLY idp_identity."user" DROP CONSTRAINT user_username_key;
       idp_identity            admin    false    216            ͺ           1259    16442    idx_user_email    INDEX     O   CREATE UNIQUE INDEX idx_user_email ON idp_identity."user" USING btree (email);
 (   DROP INDEX idp_identity.idx_user_email;
       idp_identity            admin    false    216            «           1259    16441    idx_user_username    INDEX     U   CREATE UNIQUE INDEX idx_user_username ON idp_identity."user" USING btree (username);
 +   DROP INDEX idp_identity.idx_user_username;
       idp_identity            admin    false    216            @      xΡγββ Ε ©     