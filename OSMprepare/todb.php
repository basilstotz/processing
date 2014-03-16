#!/usr/bin/php -q
<?php


$num=0;
$sum=0;

$ckey="";
$cval="";

function check_tags($relation){

  global $ckey,$cval;

  $ans=false;

  $waterway=split(" ","river riverbank stream canal dam"); 
  $landuse=split(" ","allotments basin farm farmland farmyard forest grass greenield industrial meadow orchard pasture quarry reservoir vineyard");
  $natural=split(" ","bare_rock fell grassland heath mud sand scrub stone tree tree_row wetland wood bay beach spring water arete cave_entrance cliff glacier peak ridge rock saddle scree sinkhole volcano"); 
  $place=split(" ","city town village hamlet isolated_dwelling farm");

  foreach($relation as $key => $val){
    if($key=="tag"){
      switch($val['k']){
        case "waterway": foreach($waterway as $v){
                           if($v==$val['v']){$ckey=$val['k'];$cval=$v;return true;};
                        }
                         break;
        case "landuse": foreach($landuse as $v){
                           if($v==$val['v']){$ckey=$val['k'];$cval=$v;return true;};
                        }    
                        break;
        case "natural": foreach($natural as $v){
                           if($v==$val['v']){$ckey=$val['k'];$cval=$v;return true;};
                        }
                        break;
        case "place":   foreach($place as $v){
                           if($v==$val['v']){$ckey=$val['k'];$cval=$v;return true;};
                        }
                        break;
        default:        break;
      }   

    }
  }
  return $ans;
}

$link=mysql_connect('localhost', 'root', 'herakles');
mysql_select_db("OSM");

mysql_query("DELETE FROM member where id>=0");
mysql_query("DELETE FROM relation_tag where id>=0");
mysql_query("DELETE FROM relation where id>=0");

//exit();

$xml= new SimpleXMLElement(file_get_contents("schweiz-rel-00.osm"));

$children=$xml->children();
foreach($children as $key => $node){
//   echo $key."==========================>".$node['id']."\n";


      $cc=$node->children();

      if(check_tags($cc)){

        //put relation to db......................
        //$query=sprintf("INSERT INTO relation (id,gruppe,type) VALUES ( '%s','%s','%s' )",$node['id'],$ckey,$cval);
        //$result=mysql_query($query);
        //if($result===false){echo $query."\n";echo mysql_error();exit();}

        //echo sprintf("    <relation id='%s' g='%s' t='%s' />\n",$node['id'],$ckey,$cval);
        echo sprintf("  <relation id='%s'/>\n",$node['id']);

        $index=0;

        foreach($cc as $k => $n){



          if($k=="tag"){
              //put tag to db
              $i=$node['id'];
              $k=$n['k'];
              $v=str_replace("'"," ",$n['v']);
              //$query=sprintf("INSERT INTO relation_tag (relation_id,k,v) VALUES ( '%s','%s','%s')", $i , $k , $v );
              //$result=mysql_query($query);
              // if($result===false){echo $query."\n";echo mysql_error();exit();}
              
              echo sprintf("    <tag k='%s' v='%s'/>\n",$k,$v);
              //echo "Tag: ".$n['k']."=>".$n['v']."\n";
              //$tags[$n['k']]=$n['v'];
          }


          if($k=="member"){
              //put member to db
              //$query=sprintf("INSERT INTO member (relation_id,ind,type,ref,role) VALUES ( '%s','%s','%s','%s','%s')",$node['id'],$index++,$n['type'],$n['ref'],$n['role']);
              //$result=mysql_query($query); 

               //if($result===false){echo $query."\n";echo mysql_error();exit();}
               $sum++;

              echo sprintf("    <member ref='%s' type='%s' role='%s'/>\n",$n['ref'],$n['type'],$n['role']);
              //echo "Member: ";
              //echo $n['type']."=>".$n['ref']." ".$n['role']."\n";      
          }
          
       }
      $num++;

      }else{
        ;
      }


      //$result=mysql_query("INSERT INTO node (id,lat,lon) VALUES ( '".$node['id']."','".$node['lat']."','".$node['lon']."' )");

    
} 

echo $num."/".$sum."\n";


mysql_close($link);

exit();









?>

