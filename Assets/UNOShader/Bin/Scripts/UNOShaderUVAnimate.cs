//Version=1.1
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class UNOShaderUVAnimate : MonoBehaviour
{
	public UNOShaderHelper helperComponent;
	public int matId = 0;
	
	
	void Start () 
	{
		
		//helperComponent =(UNOShaderHelper) gameObject.GetComponent<UNOShaderHelper>();
		if (renderer.sharedMaterials[matId] != null)
		{			
			if (helperComponent.materialsList[matId].DiffuseAnimateUV == UNOShaderHelper.UNOShaderHelperData.DiffuseAnimateUVs.Scroll)// if its set to scroll
			{
				if(renderer.sharedMaterials[matId].HasProperty(helperComponent.materialsList[matId].Diffuse_Name))// look for diffuse channel
				{
					helperComponent.materialsList[matId].Diffuse_UVOffset = renderer.sharedMaterials[matId].GetTextureOffset(helperComponent.materialsList[matId].Diffuse_Name);
				}
			}
			if (helperComponent.materialsList[matId].DecalAnimateUV == UNOShaderHelper.UNOShaderHelperData.DecalAnimateUVs.Scroll)// if its set to scroll
			{
				if(renderer.sharedMaterials[matId].HasProperty(helperComponent.materialsList[matId].Decal_Name))
				{
					helperComponent.materialsList[matId].Decal_UVOffset = renderer.sharedMaterials[matId].GetTextureOffset(helperComponent.materialsList[matId].Decal_Name);
				}
			}
			if (helperComponent.materialsList[matId].GlowAnimateUV == UNOShaderHelper.UNOShaderHelperData.GlowAnimateUVs.Scroll)// if its set to scroll
			{
				if(renderer.sharedMaterials[matId].HasProperty(helperComponent.materialsList[matId].Glow_Name))
				{
					helperComponent.materialsList[matId].Glow_UVOffset = renderer.sharedMaterials[matId].GetTextureOffset(helperComponent.materialsList[matId].Glow_Name);
				}
			}
		}	
	}
	
	void Update () 
	{
	
		
	}
	
	void LateUpdate()
	{	
		if (renderer.sharedMaterials[matId] != null)
		{			
			// ------------------------- Scroll  UVs -----------------------------------
			if (helperComponent.materialsList[matId].DiffuseAnimateUV == UNOShaderHelper.UNOShaderHelperData.DiffuseAnimateUVs.Scroll)// if its set to scroll
			{
				if(renderer.sharedMaterials[matId].HasProperty(helperComponent.materialsList[matId].Diffuse_Name))// look for diffuse channel
				{
					helperComponent.materialsList[matId].Diffuse_UVOffset += ( helperComponent.materialsList[matId].Diffuse_Speed * Time.deltaTime);

					if(helperComponent.materialsList[matId].DiffuseInst)//-- instantiate
					{
						renderer.materials[matId].SetTextureOffset(helperComponent.materialsList[matId].Diffuse_Name, helperComponent.materialsList[matId].Diffuse_UVOffset);
					}
					else
					{
						renderer.sharedMaterials[matId].SetTextureOffset(helperComponent.materialsList[matId].Diffuse_Name, helperComponent.materialsList[matId].Diffuse_UVOffset);
					}
				}
			}
			if (helperComponent.materialsList[matId].DecalAnimateUV == UNOShaderHelper.UNOShaderHelperData.DecalAnimateUVs.Scroll)// if its set to scroll
			{
				if(renderer.sharedMaterials[matId].HasProperty(helperComponent.materialsList[matId].Decal_Name))
				{
					helperComponent.materialsList[matId].Decal_UVOffset += ( helperComponent.materialsList[matId].Decal_Speed * Time.deltaTime );
					if(helperComponent.materialsList[matId].DecalInst  )//-- instantiate
					{
						renderer.materials[matId].SetTextureOffset(helperComponent.materialsList[matId].Decal_Name, helperComponent.materialsList[matId].Decal_UVOffset );
					}
					else
					{
						renderer.sharedMaterials[matId].SetTextureOffset(helperComponent.materialsList[matId].Decal_Name, helperComponent.materialsList[matId].Decal_UVOffset );
					}
				}
			}
			if (helperComponent.materialsList[matId].GlowAnimateUV == UNOShaderHelper.UNOShaderHelperData.GlowAnimateUVs.Scroll)// if its set to scroll
			{
				if(renderer.sharedMaterials[matId].HasProperty(helperComponent.materialsList[matId].Glow_Name))
				{
					helperComponent.materialsList[matId].Glow_UVOffset += ( helperComponent.materialsList[matId].Glow_Speed * Time.deltaTime );
					if(helperComponent.materialsList[matId].GlowInst  )//-- instantiate
					{
						renderer.materials[matId].SetTextureOffset(helperComponent.materialsList[matId].Glow_Name, helperComponent.materialsList[matId].Glow_UVOffset );
					}
					else
					{
						renderer.sharedMaterials[matId].SetTextureOffset(helperComponent.materialsList[matId].Glow_Name, helperComponent.materialsList[matId].Glow_UVOffset );
					}
				}
			}
			// ------------------------- Rotate  UVs -----------------------------------
			if (helperComponent.materialsList[matId].DiffuseAnimateUV == UNOShaderHelper.UNOShaderHelperData.DiffuseAnimateUVs.Rotate)// if its set to scroll
			{
				Matrix4x4 t = Matrix4x4.TRS(-helperComponent.materialsList[matId].DiffuseRotatePivot, Quaternion.identity, Vector3.one);
				Quaternion rotation = Quaternion.Euler
					(0, 0, helperComponent.materialsList[matId].Diffuse_UVRotate += helperComponent.materialsList[matId].DiffuseRotateSpeed * Time.deltaTime);
				Matrix4x4 r = Matrix4x4.TRS(Vector3.zero, rotation, Vector3.one);  
				Matrix4x4 tInv = Matrix4x4.TRS(helperComponent.materialsList[matId].DiffuseRotatePivot, Quaternion.identity, Vector3.one);

				if(helperComponent.materialsList[matId].DiffuseInst  )//-- instantiate
				{
					renderer.materials[matId].SetMatrix("_MatrixDiffuse", tInv*r*t);
				}
				else
				{
					renderer.sharedMaterials[matId].SetMatrix("_MatrixDiffuse", tInv*r*t);
				}
			}
			if (helperComponent.materialsList[matId].DecalAnimateUV == UNOShaderHelper.UNOShaderHelperData.DecalAnimateUVs.Rotate)// if its set to scroll
			{

				Matrix4x4 t = Matrix4x4.TRS(-helperComponent.materialsList[matId].DecalRotatePivot, Quaternion.identity, Vector3.one);
				Quaternion rotation = Quaternion.Euler
					(0, 0, helperComponent.materialsList[matId].Decal_UVRotate += helperComponent.materialsList[matId].DecalRotateSpeed * Time.deltaTime);
				Matrix4x4 r = Matrix4x4.TRS(Vector3.zero, rotation, Vector3.one);  
				Matrix4x4 tInv = Matrix4x4.TRS(helperComponent.materialsList[matId].DecalRotatePivot, Quaternion.identity, Vector3.one);

				if(helperComponent.materialsList[matId].DecalInst  )//-- instantiate
				{
					renderer.materials[matId].SetMatrix("_MatrixDecal", tInv*r*t);
				}
				else
				{
					renderer.sharedMaterials[matId].SetMatrix("_MatrixDecal", tInv*r*t);
				}
			}
			if (helperComponent.materialsList[matId].GlowAnimateUV == UNOShaderHelper.UNOShaderHelperData.GlowAnimateUVs.Rotate)// if its set to scroll
			{
				Matrix4x4 t = Matrix4x4.TRS(-helperComponent.materialsList[matId].GlowRotatePivot, Quaternion.identity, Vector3.one);
				Quaternion rotation = Quaternion.Euler
					(0, 0, helperComponent.materialsList[matId].Glow_UVRotate += helperComponent.materialsList[matId].GlowRotateSpeed * Time.deltaTime);
				Matrix4x4 r = Matrix4x4.TRS(Vector3.zero, rotation, Vector3.one);  
				Matrix4x4 tInv = Matrix4x4.TRS(helperComponent.materialsList[matId].GlowRotatePivot, Quaternion.identity, Vector3.one);

				if(helperComponent.materialsList[matId].GlowInst  )//-- instantiate
				{
					renderer.materials[matId].SetMatrix("_MatrixGlow", tInv*r*t);
				}
				else
				{
					renderer.sharedMaterials[matId].SetMatrix("_MatrixGlow", tInv*r*t);
				}
			}
		}
	}	
}
