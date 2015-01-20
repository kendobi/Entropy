//Version=1.1
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif
using System.Collections;
using System.Collections.Generic;


//[ExecuteInEditMode]
public class UNOShaderHelper : MonoBehaviour
{

	[System.Serializable]	
	public class UNOShaderHelperData
	{

		public string usingShader ="";
		public bool shaderVisible = true;
		public string name = "";
		public int renderQueue = 0;
		public int renderQueueResult = 0;
			

		public enum DiffuseAnimateUVs {No,Scroll,Rotate};
		public DiffuseAnimateUVs DiffuseAnimateUV;
		public bool DiffuseInst = true;
		public string Diffuse_Name = "_DiffuseTex";
		public Vector2 Diffuse_Speed = new Vector2( -0.4f, 0.0f );
		public Vector2 Diffuse_UVOffset = Vector2.zero;
		public float DiffuseRotateSpeed =20f;
		public float Diffuse_UVRotate = 0f;
		public Vector2 DiffuseRotatePivot = new Vector2(0.5f, 0.5f);

		public enum DecalAnimateUVs {No,Scroll,Rotate};
		public DecalAnimateUVs DecalAnimateUV;
		public bool DecalInst = true;
		public string Decal_Name = "_DecalTex";
		public Vector2 Decal_Speed = new Vector2( -0.5f, 0.0f );	
		public Vector2 Decal_UVOffset = Vector2.zero;
		public float DecalRotateSpeed = 25f;
		public float Decal_UVRotate = 0f;
		public Vector2 DecalRotatePivot = new Vector2(0.5f, 0.5f);

		public enum GlowAnimateUVs {No,Scroll,Rotate};
		public GlowAnimateUVs GlowAnimateUV;
		public bool GlowInst = true;
		public string Glow_Name = "_GlowTex";
		public Vector2 Glow_Speed = new Vector2( -0.6f, 0.0f );	
		public Vector2 Glow_UVOffset = Vector2.zero;
		public float GlowRotateSpeed = 30f;
		public float Glow_UVRotate = 0f;
		public Vector2 GlowRotatePivot = new Vector2(0.5f, 0.5f);

	}

	
	public List<UNOShaderHelperData> materialsList = new List<UNOShaderHelperData>(); // -- creates a list using class created
	
	void Start () 
	{
		for(int i = 0; i < renderer.sharedMaterials.Length; i++)
		{
			if (renderer.sharedMaterials[i] != null)
			{			
				if 	
				(
					(materialsList[i].DiffuseAnimateUV == UNOShaderHelperData.DiffuseAnimateUVs.Scroll
			 		| materialsList[i].DiffuseAnimateUV == UNOShaderHelperData.DiffuseAnimateUVs.Rotate)
					& renderer.sharedMaterials[i].HasProperty(materialsList[i].Diffuse_Name)
			 	)// if its set to scroll
				{
					UNOShaderUVAnimate tempComp = (UNOShaderUVAnimate) gameObject.AddComponent<UNOShaderUVAnimate>();
					tempComp.helperComponent = (UNOShaderHelper) gameObject.GetComponent<UNOShaderHelper>();
					tempComp.matId = i;
					return;
				}
				
				if 	
				(
					(materialsList[i].DecalAnimateUV == UNOShaderHelperData.DecalAnimateUVs.Scroll
					| materialsList[i].DecalAnimateUV == UNOShaderHelperData.DecalAnimateUVs.Rotate)
					& renderer.sharedMaterials[i].HasProperty(materialsList[i].Decal_Name)
				)// if its set to scroll
				{
					UNOShaderUVAnimate tempComp = (UNOShaderUVAnimate) gameObject.AddComponent<UNOShaderUVAnimate>();
					tempComp.helperComponent = (UNOShaderHelper) gameObject.GetComponent<UNOShaderHelper>();
					tempComp.matId = i;
					return;
				}
				
				if 	
				(
					(materialsList[i].GlowAnimateUV == UNOShaderHelperData.GlowAnimateUVs.Scroll
					| materialsList[i].GlowAnimateUV == UNOShaderHelperData.GlowAnimateUVs.Rotate)
					& renderer.sharedMaterials[i].HasProperty(materialsList[i].Glow_Name)
				)// if its set to scroll
				{
					UNOShaderUVAnimate tempComp = (UNOShaderUVAnimate) gameObject.AddComponent<UNOShaderUVAnimate>();
					tempComp.helperComponent = (UNOShaderHelper) gameObject.GetComponent<UNOShaderHelper>();
					tempComp.matId = i;
					return;	
				}
				
			}
		}	
	}
	
	void Update () 
	{
	
		
	}
	
	public void UpdateValues()//talks to the editor
	{		
		for(int i = 0; i < materialsList.Count; i++)
		{
			if (i < renderer.sharedMaterials.Length)
			{
				if (renderer.sharedMaterials[i] != null)
				{
					if(materialsList[i] != null)
					{
						materialsList[i].name = renderer.sharedMaterials[i].name;//--- set the name of material in list
						int queueSection = 2000;
						string shadertag = renderer.sharedMaterials[i].GetTag("Queue",true,"Nothing");//-- check for rendertype inside the shader
						if (shadertag == "Nothing")
						{
							queueSection = 2000;
						}
						if (shadertag == "Background")
						{	
							queueSection = 1000;
						}		
						if (shadertag == "Geometry")
						{
							queueSection = 2000;
						}		
						if (shadertag == "AlphaTest")
						{
							queueSection = 2450;
						}	
						if (shadertag == "Transparent")
						{
							queueSection = 3000;
						}	
						if (shadertag == "Overlay")
						{
							queueSection = 4000;
						}	
						renderer.sharedMaterials[i].renderQueue = (queueSection + materialsList[i].renderQueue);// set render queue
						materialsList[i].renderQueueResult = queueSection + materialsList[i].renderQueue;
					}
					
				}
			}
		}
	}
			
	public void MatchMaterialCount()
	{
		
		if(materialsList.Count != renderer.sharedMaterials.Length)
		{
			
			if (materialsList.Count < renderer.sharedMaterials.Length)
			{
				if (materialsList.Count == 0)
				{
					UNOShaderHelperData[] newUNOs = new UNOShaderHelperData[1];
					materialsList.AddRange(newUNOs);
				}
				else
				{
					int dif = renderer.sharedMaterials.Length - materialsList.Count;
					UNOShaderHelperData[] newUNOs = new UNOShaderHelperData[dif];
					materialsList.AddRange(newUNOs);
				}
			}
			else
			{
	//			if(matList.Count > matLength)
	//			{
	//				int dif = matList.Count - matLength;
	//				matList.RemoveRange(matLength,dif);	
	//			}
	//			else
	//			{
	//				
	//			}
			}
		}
	}
	
	
}
