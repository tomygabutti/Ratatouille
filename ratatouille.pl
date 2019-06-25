rata(remy, gusteaus).
rata(emile, bar).
rata(django, pizzeria).
cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5). 
cocina(colette, sopa, 7). 
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8).
cocina(amelie, ensaladaRusa, 8).
cocina(pedro, ensaladaRusa, 7.5).
cocina(juan, ratatouille, 9).
cocina(ana, ratatouille, 7.5).
trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette).
trabajaEn(gusteaus, skinner).
trabajaEn(gusteaus, horst).
trabajaEn(cafeDes2Moulins, amelie).
trabajaEn(cafeDes2Moulins, pedro).
trabajaEn(cafeUTN, juan).
trabajaEn(cafeUTN, ana).
trabajaEn(cafeUTN, maria).
trabajaEn(cafeUTN, patricia).

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(fideos, principal(ensalada, 8)).
plato(frutillasConCrema, postre(265)).
plato(ratatouille, principal(ensalada, 10)).
plato(sopa, entrada([caldo, arvejas])).
plato(salmonAsado, principal(pure, 15)).


inspeccionSatisfactoria(Restaurante):-
 trabajaEn(Restaurante, _),
 not(rata(_,Restaurante)).
 
chef(Empleado,Resto):- 
 trabajaEn(Resto,Empleado),
 cocina(Empleado,_,_).

chefecito(Rata):- 
 trabajaEn(Resto,linguini),
 rata(Rata,Resto).
 
cocinaBien(Persona,Plato):- 
 cocina(Persona,Plato,Exp),
 Exp>7.
cocinaBien(remy,Plato):-
 cocina(_,Plato,_). 

encargadoDe(Persona,Plato,Resto):-
  cocina(Persona,Plato,Exp),
  trabajaEn(Resto, Persona),
  forall((cocina(Persona2, Plato, Exp2), trabajaEn(Resto, Persona2), Persona \= Persona2), Exp > Exp2).

% saludable(NombrePlato):-
%   plato(NombrePlato, Plato),
%   calorias(Plato, C), C < 75.
% calorias(postre(X), X).
% calorias(entrada(L), X):-
%   length(L, C), X is C * 15.
% calorias(principal(Guar, Min), X):-
%   calorias(Guar, Cg), X is Cg + (Min*2).
% calorias(papaFritas, 50).
% calorias(pure, 20).
  
saludable(Plato):-
  plato(Plato, entrada(L)),
  length(L, Cantidad),
  (Cantidad * 15) < 75.
  
saludable(Plato):-
  plato(Plato, principal(Guarnicion, Tiempo)),
  Guarnicion = pure,
  (Tiempo * 5)+20 < 75.
  
saludable(Plato):-
  plato(Plato, principal(Guarnicion, Tiempo)),
  Guarnicion = papasFritas,
  (Tiempo * 5)+50 < 75.
  
saludable(Plato):-
  plato(Plato, principal(Guarnicion, Tiempo)),
  Guarnicion = ensalada,
  (Tiempo * 5) < 75.

saludable(Plato):-
  plato(Plato, postre(Cals)),
  Cals < 75.

criticaPositiva(Resto, cormillot):-
  trabajaEn(Resto, _),
  inspeccionSatisfactoria(Resto),
  forall((trabajaEn(Resto, Chef), cocina(Chef, Plato, _)), saludableParaCormillot(Plato)).
  
criticaPositiva(Resto, christophe):-
  trabajaEn(Resto, _),
  inspeccionSatisfactoria(Resto),
  findall(Chef, trabajaEn(Resto, Chef), Chefs),
  length(Chefs, Cantidad),
  Cantidad > 3.

 %findall(_, trabajaEn(Resto, _), Chefs), Solo para contar sirve
  
criticaPositiva(Resto, antonEgo):-
  trabajaEn(Resto, _),
  inspeccionSatisfactoria(Resto),
  especialista(Resto, ratatouille).
  
especialista(Resto, Plato):-
  plato(Plato, _),
  forall(trabajaEn(Resto, Chef), cocinaBien(Chef, Plato)).
  
saludableParaCormillot(Plato):-
  plato(Plato, entrada(L)),
  saludable(Plato),
  member(zanahoria, L).

saludableParaCormillot(Plato):-
  saludable(Plato),
  not(plato(Plato, entrada(__))).
 
