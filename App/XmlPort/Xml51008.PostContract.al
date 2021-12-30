/*xmlport 51008 "Post Contract"
{
    DefaultNamespace = 'urn:microsoft-dynamics-nav/xmlports/x51008';
    Direction = Both;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        /*textelement(Contracts)
        {
            tableelement(IntCRMBuffer1; "Integration CRM Buffer 1")
            {
                MinOccurs = Zero;
                XmlName = 'IntCRMBuffer1';
                UseTemporary = true;

                //Datos principales
                fieldelement(ICRMB_Unidad_de_negocio; IntCRMBuffer1."Unidad de negocio") { MinOccurs = Zero; }
                fieldelement(ICRMB_Propuesta; IntCRMBuffer1."Propuesta") { MinOccurs = Zero; }
                fieldelement(ICRMB_Oportunidad; IntCRMBuffer1."Oportunidad") { MinOccurs = Zero; }
                fieldelement(ICRMB_Cliente; IntCRMBuffer1."Cliente") { MinOccurs = Zero; }
                fieldelement(ICRMB_Tipo_de_cliente; IntCRMBuffer1."Tipo de cliente") { MinOccurs = Zero; }
                fieldelement(ICRMB_Tipo_de_documento_DP; IntCRMBuffer1."Tipo de documento DP") { MinOccurs = Zero; }
                fieldelement(ICRMB_Nro__Documento; IntCRMBuffer1."Nro. Documento") { MinOccurs = Zero; }
                fieldelement(ICRMB_Producto; IntCRMBuffer1."Producto") { MinOccurs = Zero; }
                fieldelement(ICRMB_Modelo_documeento; IntCRMBuffer1."Modelo documeento") { MinOccurs = Zero; }
                fieldelement(ICRMB_Contrato_principal; IntCRMBuffer1."Contrato principal") { MinOccurs = Zero; }
                fieldelement(ICRMB_Moneda_1; IntCRMBuffer1."Moneda_1") { MinOccurs = Zero; }
                fieldelement(ICRMB_Penalidad_Res__Contrato___; IntCRMBuffer1."Penalidad Res. Contrato(%)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Responsable_Propietario; IntCRMBuffer1."Responsable Propietario") { MinOccurs = Zero; }
                fieldelement(ICRMB_Nombre; IntCRMBuffer1."Nombre") { MinOccurs = Zero; }


                //Fechas importantes - Propios del contrato
                fieldelement(ICRMB_Fecha_inicio_contrato; IntCRMBuffer1."Fecha inicio contrato") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_fin_contrato; IntCRMBuffer1."Fecha fin contrato") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_inicio_real_contrato; IntCRMBuffer1."Fecha inicio real contrato") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_fin_real_contrato; IntCRMBuffer1."Fecha fin real contrato") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_de_firma_contrato; IntCRMBuffer1."Fecha de firma contrato") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_de_revision; IntCRMBuffer1."Fecha de revisión") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fec__Resolucion_observaciones; IntCRMBuffer1."Fec. Resolución observaciones") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_de_envio_de_contrato; IntCRMBuffer1."Fecha de envío de contrato") { MinOccurs = Zero; }


                //Informacipon cliente
                fieldelement(ICRMB_Tipo_de_documento_IF; IntCRMBuffer1."Tipo de documento IF") { MinOccurs = Zero; }
                fieldelement(ICRMB_Nro__documento_cliente; IntCRMBuffer1."Nro. documento Cliente") { MinOccurs = Zero; }
                fieldelement(ICRMB_Direccion_IC; IntCRMBuffer1."Dirección IC") { MinOccurs = Zero; }
                fieldelement(ICRMB_Pais; IntCRMBuffer1."País") { MinOccurs = Zero; }
                fieldelement(ICRMB_Departamento___Region; IntCRMBuffer1."Departamento / Región") { MinOccurs = Zero; }
                fieldelement(ICRMB_Provincia; IntCRMBuffer1."Provincia") { MinOccurs = Zero; }
                fieldelement(ICRMB_Distrito___Comuna; IntCRMBuffer1."Distrito / Comuna") { MinOccurs = Zero; }


                //Representante(s) Legal(es) ATRIA
                fieldelement(ICRMB_Representante_Atria__1_; IntCRMBuffer1."Representante Atria (1)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Representante_Atria__2_; IntCRMBuffer1."Representante Atria (2)") { MinOccurs = Zero; }


                //Representante(s) Legal(es) Cliente 1
                fieldelement(ICRMB_Representante_cliente__1_; IntCRMBuffer1."Representante cliente (1)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Cargo_RL_1; IntCRMBuffer1."Cargo RL 1") { MinOccurs = Zero; }
                fieldelement(ICRMB_Direccion_RL_; IntCRMBuffer1."Dirección RL ") { MinOccurs = Zero; }
                fieldelement(ICRMB_Correo_Electronico_RL; IntCRMBuffer1."Correo Electrónico RL") { MinOccurs = Zero; }
                fieldelement(ICRMB_telefono_celular_RL; IntCRMBuffer1."teléfono celular RL") { MinOccurs = Zero; }

                //Representante(s) Legal(es) Cliente 2
                fieldelement(ICRMB_Representante_cliente__2_; IntCRMBuffer1."Representante cliente (2)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Cargo; IntCRMBuffer1."Cargo") { MinOccurs = Zero; }
                fieldelement(ICRMB_Direccion; IntCRMBuffer1."Dirección") { MinOccurs = Zero; }
                fieldelement(ICRMB_Correo_Electronico; IntCRMBuffer1."Correo Electrónico") { MinOccurs = Zero; }
                fieldelement(ICRMB_telefono_celular; IntCRMBuffer1."teléfono celular") { MinOccurs = Zero; }

                //Escritura pública
                fieldelement(ICRMB_Nro__Partida; IntCRMBuffer1."Nro. Partida") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_escritura_publica; IntCRMBuffer1."Fecha escritura pública") { MinOccurs = Zero; }
                fieldelement(ICRMB_Notaria_escritura_publica; IntCRMBuffer1."Notaria escritura pública") { MinOccurs = Zero; }
                fieldelement(ICRMB_Ciudad_escritura_publica; IntCRMBuffer1."Ciudad escritura pública") { MinOccurs = Zero; }

                //Avales
                fieldelement(ICRMB_Aval_cliente__1_; IntCRMBuffer1."Aval cliente (1)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Aval_cliente__2_; IntCRMBuffer1."Aval cliente (2)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Aval_cliente__3_; IntCRMBuffer1."Aval cliente (3)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Aval_cliente__4_; IntCRMBuffer1."Aval cliente (4)") { MinOccurs = Zero; }

                //Alertas
                fieldelement(ICRMB_Es_una_migracion; IntCRMBuffer1."Es una migración") { MinOccurs = Zero; }//No usar
                fieldelement(ICRMB_Realizo_enc__6m_despues_inic_; IntCRMBuffer1."Realizo enc. 6m despues inic.") { MinOccurs = Zero; }//No Usar


                //Condiciones del contrato de energía
                fieldelement(ICRMB_Renovacion_automatica; IntCRMBuffer1."Renovación automática") { MinOccurs = Zero; }
                fieldelement(ICRMB_Nro__de_anios_a_renovar; IntCRMBuffer1."Nro. de años a renovar") { MinOccurs = Zero; }
                fieldelement(ICRMB_Plazo_solicitud_no_renov___m_; IntCRMBuffer1."Plazo solicitud no renov. (m)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Derecho_preferente; IntCRMBuffer1."Derecho preferente") { MinOccurs = Zero; }
                fieldelement(ICRMB_Plazo_sol__Nvas_cotizaciones; IntCRMBuffer1."Plazo sol. Nvas cotizaciones") { MinOccurs = Zero; }
                fieldelement(ICRMB_Cantidad_de_cot__solicitadas; IntCRMBuffer1."Cantidad de cot. solicitadas") { MinOccurs = Zero; }
                fieldelement(ICRMB_Plazo_inf__mejor_oferta_rec_D_; IntCRMBuffer1."Plazo inf. mejor oferta rec(D)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Plazo_inf__decisionDer_Pref_D_; IntCRMBuffer1."Plazo inf. decisiónDer.Pref(D)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Plazo_sol__aumentoPot_Ene__M_; IntCRMBuffer1."Plazo sol. aumentoPot/Ene.(M)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Plz__R__solic__aumentoPot_EneD; IntCRMBuffer1."Plz. R. solic. aumentoPot/EneD") { MinOccurs = Zero; }
                fieldelement(ICRMB_Plazo_de_emision_de_factura_D_; IntCRMBuffer1."Plazo de emisión de factura(D)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Plazo_de_pago__Dias_; IntCRMBuffer1."Plazo de pago (Días)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Plz__Pago_ent__fact__texto__CI; IntCRMBuffer1."Plz. Pago ent. fact (texto)-CI") { MinOccurs = Zero; }
                fieldelement(ICRMB_Plz__Corte_No_pago_fact__Dias_; IntCRMBuffer1."Plz. Corte No pago fact.(Días)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Plz_Peri__NoPagos_prev__Resol_; IntCRMBuffer1."Plz.Peri. NoPagos prev. Resol.") { MinOccurs = Zero; }
                fieldelement(ICRMB_Plz__Incumpli__Gen__Resol___D_; IntCRMBuffer1."Plz. Incumpli. Gen. Resol. (D)") { MinOccurs = Zero; }

                //Datos principales -
                fieldelement(ICRMB_Margen_real__USS_MWh_; IntCRMBuffer1."Margen real (US$/MWh)") { MinOccurs = Zero; }


                fieldelement(ICRMB_Contrato_Atria_S; IntCRMBuffer1."Contrato Atria S") { MinOccurs = Zero; }
                fieldelement(ICRMB_Suministro; IntCRMBuffer1."Suministro") { MinOccurs = Zero; }
                fieldelement(ICRMB_Nombre_suministro; IntCRMBuffer1."Nombre suministro") { MinOccurs = Zero; }
                fieldelement(ICRMB_Direccion_concatenada; IntCRMBuffer1."Dirección concatenada") { MinOccurs = Zero; }
                fieldelement(ICRMB_Distribuidora_S; IntCRMBuffer1."Distribuidora S") { MinOccurs = Zero; }
                fieldelement(ICRMB_Punto_suministro; IntCRMBuffer1."Punto suministro") { MinOccurs = Zero; }
                fieldelement(ICRMB_Barra_de_Referencia; IntCRMBuffer1."Barra de Referencia") { MinOccurs = Zero; }
                fieldelement(ICRMB_Propietario_S; IntCRMBuffer1."Propietario S") { MinOccurs = Zero; }
                fieldelement(ICRMB_Moneda_S; IntCRMBuffer1."Moneda S") { MinOccurs = Zero; }

                //Grilla de suministros - Asociado al contrato
                tableelement(GridSupply; "Grid Suministro")
                {
                    MinOccurs = Zero;
                    XmlName = 'GridSupply';
                    UseTemporary = true;
                    fieldelement(GS_Fecha_de_inicio__contrato_; GridSupply."Fecha de inicio (contrato)") { MinOccurs = Zero; }
                    fieldelement(GS_Fecha_de_fin__contrato_; GridSupply."Fecha de fin (contrato)") { MinOccurs = Zero; }
                    fieldelement(GS_Fecha_de_migracion; GridSupply."Fecha de migración") { MinOccurs = Zero; }
                    fieldelement(GS_Exceso_potencia____; GridSupply."Exceso potencia (%)") { MinOccurs = Zero; }
                    fieldelement(GS_Exceso_energia____; GridSupply."Exceso energía (%)") { MinOccurs = Zero; }
                    fieldelement(GS_Potencia_Min__Facturable_kW___; GridSupply."Potencia Mín. Facturable kW(%)") { MinOccurs = Zero; }
                    fieldelement(GS_Potencia_Min__Fact__kW__Monto_; GridSupply."Potencia Min. Fact. kW (Monto)") { MinOccurs = Zero; }
                    fieldelement(GS_Potencia_Estacional; GridSupply."Potencia Estacional") { MinOccurs = Zero; }
                    fieldelement(GS_Precio_Escalonado; GridSupply."Precio Escalonado") { MinOccurs = Zero; }
                    fieldelement(GS_Max__PC___HP__kW_; GridSupply."Max. PC - HP (kW)") { MinOccurs = Zero; }
                    fieldelement(GS_Max__PC___HFP__kW_; GridSupply."Max. PC - HFP (kW)") { MinOccurs = Zero; }
                }
                // fieldelement(ICRMB_Fecha_de_carta_pre_aviso; IntCRMBuffer1."Fecha de carta pre aviso") { MinOccurs = Zero; }
                // fieldelement(ICRMB_Fecha_de_carta_distribuidora; IntCRMBuffer1."Fecha de carta distribuidora") { MinOccurs = Zero; }
                // fieldelement(ICRMB_CorrelativoCarta_distribuidora; IntCRMBuffer1."CorrelativoCarta distribuidora") { MinOccurs = Zero; }

                //Grilla Potencia contratada ATRIA
                tableelement(GrillaPotenciaContratada; "Grilla Potencia Contratada")
                {
                    MinOccurs = Zero;
                    XmlName = 'GrillaPotenciaContratada';
                    UseTemporary = true;
                    fieldelement(GPC_Mes; GrillaPotenciaContratada."Mes") { MinOccurs = Zero; }
                    fieldelement(GPC_Potencia_Contratada_HP__kW_; GrillaPotenciaContratada."Potencia Contratada HP (kW)") { MinOccurs = Zero; }
                    fieldelement(GPC_Potencia_Contratada_HFP__kW_; GrillaPotenciaContratada."Potencia Contratada HFP (kW)") { MinOccurs = Zero; }

                }

                //Grilla Rango de Precios
                tableelement(GrillaRangoPrecios; "Grilla Rango Precios")
                {
                    MinOccurs = Zero;
                    XmlName = 'GrillaRangoPrecios';
                    UseTemporary = true;
                    fieldelement(GRP_Fecha_de_inicio_P; GrillaRangoPrecios."Fecha de inicio P") { MinOccurs = Zero; }
                    fieldelement(GRP_Fecha_de_fin_P; GrillaRangoPrecios."Fecha de fin P") { MinOccurs = Zero; }
                    fieldelement(GRP_Moneda_Precio_energia_HP_y_HFP; GrillaRangoPrecios."Moneda Precio energia HP y HFP") { MinOccurs = Zero; }
                    fieldelement(GRP_Tipo_de_cambio; GrillaRangoPrecios."Tipo de cambio") { MinOccurs = Zero; }
                    fieldelement(GRP_Precio_energia_HP_HFP_USS_MWh_; GrillaRangoPrecios."Precio energía HP/HFP(US$/MWh)") { MinOccurs = Zero; }
                    fieldelement(GRP_Prec_energia_HP_HFP_O_Mon_kWh_; GrillaRangoPrecios."Prec energía HP/HFP(O-Mon/kWh)") { MinOccurs = Zero; }
                }


                //General - Informacipon de contrato de financiamiento v1
                fieldelement(ICRMB_Contrato_Atria; IntCRMBuffer1."Contrato Atria") { MinOccurs = Zero; }
                fieldelement(ICRMB_Moneda; IntCRMBuffer1."Moneda") { MinOccurs = Zero; }
                fieldelement(ICRMB_Propietario; IntCRMBuffer1."Propietario") { MinOccurs = Zero; }

                //Index - Relacionado al contrato de energía
                fieldelement(ICRMB_Energia_HP_Index; IntCRMBuffer1."Energía HP Index") { MinOccurs = Zero; }
                fieldelement(ICRMB_Valor_Index_Energia_HP___PP; IntCRMBuffer1."Valor Index Energía HP - PP") { MinOccurs = Zero; }
                fieldelement(ICRMB_Mes_Vigencia; IntCRMBuffer1."Mes Vigencia") { MinOccurs = Zero; }
                fieldelement(ICRMB_Anio_vigencia; IntCRMBuffer1."Año vigencia") { MinOccurs = Zero; }
                fieldelement(ICRMB_Energia_HFP_Index; IntCRMBuffer1."Energía HFP Index") { MinOccurs = Zero; }
                fieldelement(ICRMB_Valor_Index_Energia_HFP___PP; IntCRMBuffer1."Valor Index Energía HFP - PP") { MinOccurs = Zero; }
                fieldelement(ICRMB_Potencia_Index; IntCRMBuffer1."Potencia Index") { MinOccurs = Zero; }
                fieldelement(ICRMB_Valor_Index_Potencia___PP; IntCRMBuffer1."Valor Index Potencia - PP") { MinOccurs = Zero; }

                //General - Informacipon de contrato de financiamiento v2
                fieldelement(ICRMB_Importe_financiamiento_G; IntCRMBuffer1."Importe financiamiento G") { MinOccurs = Zero; }
                fieldelement(ICRMB_Importe_financiamiento_LetrasG; IntCRMBuffer1."Importe financiamiento LetrasG") { MinOccurs = Zero; }
                fieldelement(ICRMB_Concepto_del_prestamo_G; IntCRMBuffer1."Concepto del préstamo G") { MinOccurs = Zero; }


                //Contrato PPA relacionado - Solo se usa para adenda de contrato de energía o contrato de financiamiento
                fieldelement(ICRMB_Contrato_relacionado_PPA_CR; IntCRMBuffer1."Contrato relacionado PPA CR") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_inicio_contrato_rel__CR; IntCRMBuffer1."Fecha inicio contrato rel. CR") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_de_fin_contrato_rel__CR; IntCRMBuffer1."Fecha de fin contrato rel. CR") { MinOccurs = Zero; }


                //Datos Banco Cliente - Banco relacionado al contrato de financiamiento
                tableelement(CustomerBankBuffer; "Customer Bank Buffer")
                {
                    MinOccurs = Zero;
                    XmlName = 'CustomerBankBuffer';
                    UseTemporary = true;
                    fieldelement(CBB_LineNo; CustomerBankBuffer."Entry No.") { MinOccurs = Zero; }
                    fieldelement(CBB_Banco_del_cliente_DBC; CustomerBankBuffer."Banco del cliente DBC 1") { MinOccurs = Zero; }
                    fieldelement(CBB_Tipo_cuenta_bancaria_DBC; CustomerBankBuffer."Tipo cuenta bancaria DBC 1") { MinOccurs = Zero; }
                    fieldelement(CBB_Nro__cuenta_banc_cliente_DBC; CustomerBankBuffer."Nro. cuenta banc.cliente DBC 1") { MinOccurs = Zero; }
                    fieldelement(CBB_CCI_DBC; CustomerBankBuffer."CCI DBC 1") { MinOccurs = Zero; }
                    fieldelement(CBB_Nro__cuenta_detraccion_DBC; CustomerBankBuffer."Nro. cuenta detracción DBC 1") { MinOccurs = Zero; }
                }

                tableelement(MinEnergyGrid; "Min. Energy Grid")
                {
                    MinOccurs = Zero;
                    XmlName = 'MinEnergyGrid';
                    UseTemporary = true;
                    fieldelement(MEG_Fecha_de_inicio; MinEnergyGrid."Fecha de inicio") { MinOccurs = Zero; }
                    fieldelement(MEG_Fecha_de_fin; MinEnergyGrid."Fecha de fin") { MinOccurs = Zero; }
                    fieldelement(MEG_Energia_minima_esperada_MWh; MinEnergyGrid."Energía mínima esperada MWh") { MinOccurs = Zero; }
                }

                //Financiamiento ahorro - Pertenece al contrato de financiamiento ahorro adelantado
                fieldelement(ICRMB_Fecha_Inicio_Repago_DLL; IntCRMBuffer1."Fecha Inicio Repago DLL") { MinOccurs = Zero; }
                fieldelement(ICRMB_Consumo_minimo_anual__MWh_; IntCRMBuffer1."Consumo mínimo anual (MWh)") { MinOccurs = Zero; }
                fieldelement(ICRMB_potencia_contratada_anual_MWh_; IntCRMBuffer1."potencia contratada anual(MWh)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_Analisis_cons__energia; IntCRMBuffer1."Fecha Análisis cons. energía") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fec_Ini_Ult__peri__energia_min; IntCRMBuffer1."Fec.Ini.Últ. peri. energía mín") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fec_fin_ult_peri__energia_min_; IntCRMBuffer1."Fec.fin.últ.peri. energía mín.") { MinOccurs = Zero; }
                fieldelement(ICRMB_Ejec__negocios_financieros_1; IntCRMBuffer1."Ejec. negocios financieros 1") { MinOccurs = Zero; }


                //Evaluación consumo energía - Pertenece al contrato, puntualmente a financiamiento.
                fieldelement(ICRMB_Cons_Total_Energia_espe___MWh_; IntCRMBuffer1."Cons.Total Energía espe. (MWh)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Max__energia_min__espe___MWh_; IntCRMBuffer1."Máx. energía mín. espe. (MWh)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Cons_Ene_min__ult__Peri___MWh_; IntCRMBuffer1."Cons.Ene.mín. últ. Peri. (MWh)") { MinOccurs = Zero; }


                //Pertenece al contrato de financiamiento
                fieldelement(ICRMB_Ejec__negocios_financieros_2; IntCRMBuffer1."Ejec. negocios financieros 2") { MinOccurs = Zero; }
                fieldelement(ICRMB_Precio_energia_USS_MWh__Letras; IntCRMBuffer1."Precio energía(US$/MWh) Letras") { MinOccurs = Zero; }
                fieldelement(ICRMB_Ejec__negocios_financieros_3; IntCRMBuffer1."Ejec. negocios financieros 3") { MinOccurs = Zero; }
                // fieldelement(ICRMB_Importe_financiamiento; IntCRMBuffer1."Importe financiamiento") { MinOccurs = Zero; }
                // fieldelement(ICRMB_Importe_financiamiento_letras; IntCRMBuffer1."Importe financiamiento letras") { MinOccurs = Zero; }
                // fieldelement(ICRMB_Concepto_del_prestamo_G2; IntCRMBuffer1."Concepto del préstamo G2") { MinOccurs = Zero; }


                //Contrato PPA relacionado - Solo se usa para adenda de contrato de energía o contrato de financiamiento (Opcional)
                fieldelement(ICRMB_Contrato_relacionado_PPA; IntCRMBuffer1."Contrato relacionado PPA") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_de_inicio_contrato_rel_; IntCRMBuffer1."Fecha de inicio contrato rel.") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_de_fin_contrato_rel_; IntCRMBuffer1."Fecha de fin contrato rel.") { MinOccurs = Zero; }

                // fieldelement(ICRMB_Banco_del_cliente_DBC_2; IntCRMBuffer1."Banco del cliente DBC 2") { MinOccurs = Zero; }
                // fieldelement(ICRMB_Tipo_cuenta_bancaria_DBC_2; IntCRMBuffer1."Tipo cuenta bancaria DBC 2") { MinOccurs = Zero; }
                // fieldelement(ICRMB_Nro__cuenta_banc_cliente_DBC_2; IntCRMBuffer1."Nro. cuenta banc.cliente DBC 2") { MinOccurs = Zero; }
                // fieldelement(ICRMB_CCI_DBC_2; IntCRMBuffer1."CCI DBC 2") { MinOccurs = Zero; }
                // fieldelement(ICRMB_Nro__cuenta_detraccion_DBC_2; IntCRMBuffer1."Nro. cuenta detracción DBC 2") { MinOccurs = Zero; }

                //General - Informacipon de contrato de financiamiento v3
                fieldelement(ICRMB_Monto_Cuota; IntCRMBuffer1."Monto Cuota") { MinOccurs = Zero; }
                fieldelement(ICRMB_Monto_Cuota_en_letras; IntCRMBuffer1."Monto Cuota en letras") { MinOccurs = Zero; }
                fieldelement(ICRMB_Numero_cuotas_financiamiento; IntCRMBuffer1."Número cuotas financiamiento") { MinOccurs = Zero; }
                fieldelement(ICRMB_Numero_cuotas_finan___letras_; IntCRMBuffer1."Número cuotas finan. (letras)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Tasa__anual____; IntCRMBuffer1."Tasa  anual (%)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Tasa_nominal_anual____; IntCRMBuffer1."Tasa nominal anual (%)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Tasa_efectiva_anual____; IntCRMBuffer1."Tasa efectiva anual (%)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Tasa_efectiva_anual_en_letras; IntCRMBuffer1."Tasa efectiva anual en letras") { MinOccurs = Zero; }
                fieldelement(ICRMB_Tasa_moratoria____; IntCRMBuffer1."Tasa moratoria (%)") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_deuda_distribuidora; IntCRMBuffer1."Fecha deuda distribuidora") { MinOccurs = Zero; }
                fieldelement(ICRMB_Distribuidora_G; IntCRMBuffer1."Distribuidora G") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_de_emision_pagare; IntCRMBuffer1."Fecha de emisión pagare") { MinOccurs = Zero; }
                fieldelement(ICRMB_Dia_de_pago; IntCRMBuffer1."Día de pago") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_primera_cuota_de_pago; IntCRMBuffer1."Fecha primera cuota de pago") { MinOccurs = Zero; }
                fieldelement(ICRMB_Fecha_ultima_cuota_de_pago; IntCRMBuffer1."Fecha última cuota de pago") { MinOccurs = Zero; }
                fieldelement(ICRMB_Ejec__negocios_financieros_G; IntCRMBuffer1."Ejec. negocios financieros G") { MinOccurs = Zero; }

                tableelement(GridPayment; "Grid Payment")
                {
                    MinOccurs = Zero;
                    XmlName = 'GridPayment';
                    UseTemporary = true;
                    fieldelement(GP_Nro__de_cuota; GridPayment."Nro. de cuota") { MinOccurs = Zero; }
                    fieldelement(GP_Saldo; GridPayment."Saldo") { MinOccurs = Zero; }
                    fieldelement(GP_Capital; GridPayment."Capital") { MinOccurs = Zero; }
                    fieldelement(GP_Intereses; GridPayment."Intereses") { MinOccurs = Zero; }
                    fieldelement(GP_Cuota; GridPayment."Cuota") { MinOccurs = Zero; }
                    fieldelement(GP_Dias; GridPayment."Días") { MinOccurs = Zero; }
                    fieldelement(GP_Fecha_de_pago; GridPayment."Fecha de pago") { MinOccurs = Zero; }
                    fieldelement(GP_IGV_Intereses; GridPayment."IGV Intereses") { MinOccurs = Zero; }
                    fieldelement(GP_Cuota_con_IGV; GridPayment."Cuota con IGV") { MinOccurs = Zero; }
                }

                trigger OnAfterInsertRecord()
                begin
                    if not IntCRMBuffer1.IsEmpty then begin
                        ResponseXML.Init();
                        ResponseXML."Response Code" := '0000';
                        ResponseXML.Status := 'SUCCES';
                        ResponseXML."Response Text" := StrSubstNo('Se registró correctamente el contrato N° %1', IntCRMBuffer1."Nro. documento");
                        ResponseXML.Insert();

                    end else begin
                        ResponseXML.Init();
                        ResponseXML."Response Code" := '0001';
                        ResponseXML.Status := 'ERROR';
                        ResponseXML."Response Text" := 'No se pudo registrar el contrato';
                        ResponseXML.Insert();
                    end;
                end;
            }
        }
    }

    var
        ResponseXML: Record "Response XML" temporary;

    procedure GetResponse(var pResponseXML: Record "Response XML" temporary)
    begin
        pResponseXML.Reset();
        pResponseXML.DeleteAll();

        ResponseXML.Reset();
        if ResponseXML.FindFirst() then
            repeat
                pResponseXML.Init();
                pResponseXML.TransferFields(ResponseXML, true);
                pResponseXML.Insert();
            until ResponseXML.Next() = 0;

        ResponseXML.Reset();
        ResponseXML.DeleteAll();
    end;
}*/