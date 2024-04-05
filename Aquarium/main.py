import db
from flask import Flask, render_template, request, redirect, url_for, session
from random import randint
from passlib.context import CryptContext
password_ctx = CryptContext(schemes=['bcrypt']) 



app = Flask(__name__)


# fonction principale permettant juste aux utilisateurs l'accès à 
# d'autres informations.

@app.route("/accueil")
def accueil():
    return render_template("accueil.html")

# Pour l'instant dans information, on a pas grand chose mais
# l'aura surement des informations sur l'aquarium et autres choses 
# qu'on ne sait pas encore

@app.route("/informations")
def information():
    return render_template("info.html")

# Cette fonction nous renvoie juste vers la liste des espèces qui
# qui vivent dans l'aquarium 
@app.route("/especes")
def espece():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select * from espece")
            result = cur.fetchall()
            #print(result)
    return render_template("especes.html", eplist = result)


@app.route("/especes/<idespece>")
def composition(idespece):
    with db.connect() as conn: # renvoie le nom de l'espèce, numero de bassin et le nom du secteur
        with conn.cursor() as cur:
            cur.execute("select * from animal natural join espece natural join vivent natural join bassin natural join secteur where idespece = %s", (idespece, )) 
            code = cur.fetchone()
            #print(code)
    with db.connect() as conn: # renvoie juste le nombre d'espèces (à ameliorer)
        with conn.cursor() as cur:
            cur.execute("select count(idanimal) as nb from animal where idespece = %s", (idespece, )) 
            code1 = cur.fetchone()
            #print(code1)
    with db.connect() as conn: # renvoie les animaux composants les espèces 
        with conn.cursor() as cur:
            cur.execute("select nom from animal where idespece = %s", (idespece, )) 
            code2 = cur.fetchall()
            #print(code2)
    return render_template("composition.html", id=idespece, compo=code, nombre=code1, compo1=code2)


@app.route("/especes/<idespece>/<nom>") # cette fonction nous dirige vers l'animal donc 
def animaux(idespece, nom):             # dont on a cliqué sur le nom pour des infos 
    with db.connect() as conn:          # sur ce dernier
        with conn.cursor() as cur:
            cur.execute("select * from animal natural join espece natural join vivent natural join bassin natural join secteur where idespece = %s and nom = %s", (idespece, nom, )) 
            code3 = cur.fetchall()
            print(code3)
    return render_template("animaux.html", animaux=code3)


@app.route("/bassin") # fonction renvoyant la liste des bassins 
def liste_bassin():
    with db.connect() as conn:          
        with conn.cursor() as cur:
            cur.execute("select * from bassin order by numbassin asc") 
            code4 = cur.fetchall()
            #print(code4)
    return render_template("bassin.html", bassin=code4)


@app.route("/bassin/<numbassin>")
def compo_bassin(numbassin):
    with db.connect() as conn:        # fonction permettant de recuperer le numbassin, le secteur  
        with conn.cursor() as cur:
            cur.execute("select distinct * from animal natural join espece natural join vivent natural join bassin natural join secteur where numBassin = %s", (numbassin,)) 
            code5 = cur.fetchone()
            print(code5)
    with db.connect() as conn:        # fonction permettant de prendre les espèces sans repetition 
        with conn.cursor() as cur:
            cur.execute("select numBassin, nom_espece from bassin natural join vivent natural join espece where numBassin = %s", (numbassin,)) 
            code6 = cur.fetchall()
            #print(code6)
    with db.connect() as conn:    # fonction permettant de proposer des activites     
        with conn.cursor() as cur:
            cur.execute("select * from activite where numBassin = %s", (numbassin,)) 
            code7 = cur.fetchall()
            print(code7)
    return render_template("compo_bassin.html", compobassin=code5, compo1bassin=code6, acti=code7)


@app.route("/visiteur")  # fonction permettant aux visiteurs de prendre rdv et autres ...
def visite():
    jour = ['Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi']
    return render_template("visiteur.html", jours = jour)


@app.route("/propose", methods = ['POST']) # fonction permettant de proposer des activites 
def propose():                             # aux visiteurs
    jour = request.form.get("jour",None)
    print(jour)
    #heure = request.form.get("horaire",None)
    with db.connect() as conn:        
        with conn.cursor() as cur:
            cur.execute("select * from activite natural join bassin") 
            code8 = cur.fetchall()
            print(code8)
    return render_template("propose.html", pro=code8, jour_visite=jour)
    


@app.route("/lien")  # Dans lien, on peut trouver des informations internes ou externes
def lien():
    return render_template("lien.html")

@app.route("/connexion")      # Fonction permettant aux employés de s'identifier
def connexion():
    return render_template("connexion.html")


@app.route("/employe", methods=["post"])   # Après authentification, fonction dirigeant les 
def employe():                             # les employés sur les pages d'acceuil
    login = request.form.get("user", None)
    motdp = request.form.get("pass", None)
    print(motdp)
    with db.connect() as conn: # fonction permettant d'afficher l'emploi du temps des utilisateurs
        with conn.cursor() as cur:
            cur.execute("select * from activite natural join occupe natural join employe")
            code9 = cur.fetchall()
    with db.connect() as conn: # fonction  utilisateurs
        with conn.cursor() as cur:
            cur.execute("select * from employe")
            code22 = cur.fetchall()
            #print(code9)
    with db.connect() as conn:      # fonction permettant de comparer si l'utilisateur est un resposable
        with conn.cursor() as cur:
            cur.execute("select distinct  numBassin, numSS, nom from activite natural join bassin natural join employe")
            code10 = cur.fetchall()
            print(code10)
    
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select * from mot_de_passe natural join employe")
            for result in cur:
                if result.nom+"."+result.prenom == login:
                    log1 = result.nom
                    log2 = result.prenom
                    if password_ctx.verify(motdp, result.mdt):
                        return render_template("employe.html", log1=log1, log2=log2, emploi=code9, emploi2=code10, emploi3=code22)
    return redirect(url_for('accueil') )




@app.route("/employe/<numbassin>")
def respo(numbassin):
    lst = ['nomAc','jour','heure','situation','numBaasin']
    with db.connect() as conn:    # fonction permettant de proposer des activites     
        with conn.cursor() as cur:
            cur.execute("select * from activite where numBassin = %s", (numbassin,)) 
            code11 = cur.fetchall()
    return render_template("respo.html", new_bassin=numbassin, tout_acti=code11, col = lst)


@app.route("/employe/<numbassin>/ajout_activite", methods=["post"])
def insert(numbassin):       # fonction permettant d'inserer une 
    nomact = request.form.get("name")     # nouvelle activité  
    jouract = request.form.get("jour")
    heureact = request.form.get("heure")
    situact = request.form.get("situa")
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("insert into activite(nomAc, jour, heure, situation, numBassin) values (%s,%s,%s,%s,%s)", (nomact, jouract, heureact, situact, numbassin))
    return redirect(url_for( 'respo', numbassin=numbassin ))


@app.route("/employe/<numbassin>/supp_activite", methods=["post"])
def delete(numbassin):                            # fonction permettant de supprimer
    idact =  request.form.get("id")               # une activité
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("delete from activite where idactivite = %s", (idact,))
    return redirect(url_for( 'respo', numbassin=numbassin ))

@app.route("/employe/<numbassin>/update_activite", methods=["post"])
def update(numbassin):
    act = request.form.get("act")
    modif =  request.form.get("modif")             # fonction permettant de modifier une heure d'activité
    amodif =  request.form.get("amodif")
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("update activite set " + amodif + "= %s where idActivite = %s and numbassin = %s", (modif,act,numbassin))
    return redirect(url_for( 'respo', numbassin=numbassin ))




@app.route("/employe/<numbassin>/choix")  # fonction permettant aux responsables 
def choix(numbassin):                     # de choisir une activité pour affecter un employé
    with db.connect() as conn:        
        with conn.cursor() as cur:
            cur.execute("select * from employe") 
            code12 = cur.fetchall()
    with db.connect() as conn:        
        with conn.cursor() as cur:
            cur.execute("select * from activite where numbassin = %s", (numbassin, )) 
            code13 = cur.fetchall()
    with db.connect() as conn:        
        with conn.cursor() as cur:
            cur.execute("select * from activite natural join occupe natural join employe where numbassin = %s", (numbassin, )) 
            code_liste = cur.fetchall()
    
    return render_template("choix.html", choix=code12, numbassin=numbassin, liste_choix=code13, code_liste=code_liste)


@app.route("/employe/<numbassin>/choix/affectation", methods=['post'])
def affectation(numbassin):                           
    numemploye =  request.form.get("pref1")      # fonction permettant d'affecter un employé à une
    idactivite = request.form.get("pref2")       # activité du bassin
    print(numemploye)
    print(idactivite)
    with db.connect() as conn:        
        with conn.cursor() as cur:
            cur.execute("insert into occupe values (%s, %s)", (numemploye, idactivite)) 
    return redirect(url_for( 'respo', numbassin=numbassin ))
    #return redirect(url_for('choix', numbassin=numbassin ))


@app.route("/employe/<numbassin>/animaux") # fonction permettant à un responsable de voir 
def animaux_2(numbassin):                   # le liste des animaux de son bassin 
    lst = ['nom','sexe','signeDis','lieuNais','dateA','dateD','situation','idespece']                
    with db.connect() as conn:        
        with conn.cursor() as cur:
            cur.execute("select idanimal, nom, idespece from animal natural join vivent where numbassin = %s", (numbassin, )) 
            code14 = cur.fetchall()
    return render_template("respo_animal.html", anilist=code14, numbassin=numbassin, col = lst )
    


@app.route("/employe/<numbassin>/animaux/update_2", methods=['post'])  # fonction permettant aux responsable
def update_2(numbassin):                                               # de mettre à jour la liste des animaux
    nom_co = request.form.get("nom_col")
    print(nom_co)
    valeur = request.form.get("valeur")
    iden = request.form.get("iden")     
    with db.connect() as conn:        
        with conn.cursor() as cur:
            cur.execute("update animal set " + nom_co + "= %s where idanimal = %s", (valeur, iden)) 
    return redirect(url_for( 'animaux_2', numbassin=numbassin))









@app.route("/employe/gestionnaire") # fonction permettant aux gestionnnaires la liste 
def gestionnaire():                 # des options qui leurs sont dediées 
    return render_template("gestionnaire.html")


@app.route("/formu_gestion")
def formu_gestion():
    return render_template("formu_gestion.html")




@app.route("/fiche_employe", methods=['post'])
def fiche_employe():
    lst_2 = ['numSS', 'nom', 'prenom', 'adresse', 'dateNais', 'gestionnaire']
    verif_nom = request.form.get("user11")
    verif_pre = request.form.get("user12") 
    verif_num = request.form.get("numss")
    with db.connect() as conn:        # liste de tous les employé pour pouvoir voir
        with conn.cursor() as cur:    # leur fiche
            cur.execute("select * from employe")
            code17 = cur.fetchall()
    with db.connect() as conn:        
        with conn.cursor() as cur:
            cur.execute("select * from employe natural join bassin")
            code18 = cur.fetchall()
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("drop view if exists liste")
            cur.execute("create view liste as (select nom, prenom, sum(durée) as heure_T from occupe natural join employe group by nom,prenom)")
            cur.execute("select * from liste")
            code_liste = cur.fetchall()
    with db.connect() as conn:        
        with conn.cursor() as cur:                                             # fonction permettant de verifier que la personne
            cur.execute("select nom, prenom, numss, gestionnaire from employe") # qui essaye de se connecter est un gestionnaire
            for elem in cur:
                if elem[0] == verif_nom and elem[1] == verif_pre:
                    if elem[2]==verif_num and elem[3] == True:
                        nom = elem[0]
                        return render_template("fiche_employe.html", liste_employe=code17, nom=nom, lst_2=lst_2, lst_3=code18, code_liste=code_liste)
    return redirect(url_for('accueil') )


@app.route("/fiche_employe/update_3", methods=['post'])
def update_3():
    numss = request.form.get("numss2")
    modif2 =  request.form.get("modif2")             # fonction permettant de modifier des information sur 
    amodif2 =  request.form.get("amodif2")           # les employés
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("update employe set " + amodif2 + "= %s where numss = %s", (modif2,numss))
    return redirect(url_for('formu_gestion') )




@app.route("/fiche_employe/delete_4", methods=['post'])  # fonction permettant à un responsable 
def delete_4():                                          # de retirer la responsabilité d'un bassin
    bas1 = request.form.get("bas1")                      # à un employé
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("update bassin set numss = null where numbassin = %s", (bas1,))
    return redirect(url_for('formu_gestion') )


@app.route("/fiche_employe/update_5", methods=['post'])   # Après avoir retirer la responsabilté d'un bassin 
def update_5():                                           # à un employé, cette fonction permet à un gestionnaie
    bas1 = request.form.get("bas1")                       # de la donner à un autre employé
    ajout = request.form.get("ajout")
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("update bassin set numss = %s where numbassin = %s", (ajout,bas1))
    return redirect(url_for('formu_gestion') )


@app.route("/fiche_employe/gestion")     # Fonction permettant à un gestionnaire d'avoir accès aux 
def gestion():                           # stocks de nourritures
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select * from nourriture")
            code19 = cur.fetchall()
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("select mange.idnourriture,food.nom from (select * from nourriture) as food,mange group by mange.idnourriture,food.idnourriture,food.qstock,food.nom having sum(quantité)*7 > food.qstock and mange.idnourriture = food.idnourriture")
            code20 = cur.fetchall()
    return render_template("gestion.html", g=code19, nourri=code19,verif=code20 )    



@app.route("/fiche_employe/gestion/update_6", methods=['post'])    # fonction permettant aux gestionnaires de mettre
def update_6():                                                    # à jour la quantité de stock de nourriture
    qstock = request.form.get("qstock")                                           
    aliment = request.form.get("aliment")                       
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("update nourriture set qstock = %s where nom = %s", (qstock,aliment))
    return redirect(url_for('gestion') )



@app.route("/actualite")              # fonction permettant de voir les actualités de l'aquarium sur le 
def actualite():                      # le site de la mairie. Cette fonction utilise une vue.
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("drop view if exists cinqN")
            cur.execute("create view cinqN (nom, nom_espece, numBassin, nomSect, lieuNais) as (select nom, nom_espece, numBassin, nomSect, lieuNais from animal natural join espece natural join vivent natural join bassin natural join secteur order by dateA desc limit 5)")
            cur.execute("select * from cinqN")
            code21 = cur.fetchall()
            print(code21)
    return render_template("actualite.html", mairie = code21)














"""
@app.route("/inscription")
def inscription():
    return render_template("inscription.html")


@app.route("/inscription2", methods=["post"])
def inscription2():
    num =  request.form.get("id")       # fonction permettant d'inserer une 
    nom = request.form.get("name")     # nouvelle activité  
    pre = request.form.get("jour")
    adr = request.form.get("heure")
    date = request.form.get("situa")
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("insert into employe values (%s,%s,%s,%s,%s)", (num, nom, pre, adr,  date))
    return redirect(url_for('connexion' ))
"""


if __name__ == '__main__':
    app.run()